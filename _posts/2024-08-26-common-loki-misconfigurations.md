---
layout: post
title: Common Loki Misconfigurations
date: 2024-08-26
---
Loki is fairly straight forward to setup. Unlike, Prometheus you don't even need to define scrape targets in the configuration. Instead, in the config for your logging agent of choice, you define the Loki endpoint, and you are off to the races... unless of course, you have one of a whole suite of misconfigurations that is preventing your logging agent from pushing your logs to the Loki ingestor. In particular, the Loki documentation has very little to say about the usecase where you have your grafana/loki deployment on server A, and your application with the logs you want to send to it on servers B, C... etc. even though this is the typical usecase where I want an aggregated logging solution in the first place! And it is all too easy to think you have everything setup correctly, and then go to add Loki as a data source in Grafana, and get hit with the dreaded "Data source connected, but no labels received" message.

Here are a list of potential issues to check if you're running into this message. Of course there are a lot of other potential issues to check for depending on what it is your trying to do, but this is just a usecase where there are multiple servers involved, and you are running your application with the logs you want, and your logging agent in docker containers.

## Troubleshooting List

- Basic network connectivity: This is always the first thing you are going to want to check. Make sure your servers can connect to the internet, there's no point in figuring anything else out on this list unless you have an HTTP and HTTPS connection.

- Firewall rules: In addition to making sure about HTTP and HTTPS, you'll want to make sure you don't have any firewall rules blocking the ports being used by your docker containers.

- Docker containers are all running: Check with `docker ps`. If anything failed, or is in a restart loop, check the logs of the container, and fix whatever issue is preventing the container from running.

- Docker networking: If you can't even add Loki as a data source, check to make sure your Grafana and Loki containers can communicate with one another. `docker network connect <network name> <container name>` can add containers to a docker network. A similar consideration goes if you are using a reverse proxy service alongside your logging agent.

- Expose your port: You will need to expose the port of the logging agent, or the reverse proxy service you put in front of it.

- Check that your logging agent is ready: A logging agent like promtail runs a web service that is handy for debugging and troubleshooting. It is typically located at `<ip_address>:9080` and you can check if it's ready, and what logs it has available.

- Make sure you add the path to your application's logs as a volume for your logging agent container. In the case of a docker container, that's going to be the `/var/lib/docker/containers/*` directory. If you only want a specific container, there are some tricks you can do in an ansible playbook to configure that.

## Configuration Considerations

For Loki you will almost definitely want to tweak some of the values under the `limits_config` block. By default, `ingestion_rate_mb` is only 3 or 4 I think. And the value of `ingestion_burst_size_mb` should exceed the size of any individual log file you are sending. Leaving these at their default will make Loki very slow, especially when logs are being initially ingested.

As mentioned, earlier, if you want to only collect logs for a particular docker container, ansible makes this very straight forward. First you need to register a variable.

```
- name: Deploy docker container
  community.docker.docker_container:
    name: my_application
    image: "{{ app_image }}"
    state: started
    restart-policy: always
    . . .
  register: my_container
```

The `register` keyword defines a variable that has data regarding the task's status, and the module's return data. You can use the debug module if you want to take a look at the sort of data available. In this case, we want the container id, so we'll register that as a fact.

```
- name: Set container id fact
  ansible.builtin.set_fact:
    container_id: "{{ my_container.container.Id }}"
```

Now that we have a fact/variable that corresponds to the container ID we can include it in the config template for the logging agent. This is what it would look like in promtail:

```
scrape_configs:
  static_configs:
  - targets:
      - localhost
    labels:
      job: application
      host: "{{ inventory_hostname }}"
      __path__: "/var/lib/docker/containers/{{ container_id }}/*.log"
```

## Next Steps

Now (hopefully!) you are receiving your logs. Probably the next thing you would want is to include is some authentication to your logs so you aren't unnecessarily exposing all the details of your logs to the entire internet. This is beyond the scope of this blog post, but there are some helpful suggestions about it [here](https://grafana.com/docs/loki/latest/operations/authentication/), and [here](https://prometheus.io/docs/guides/basic-auth/).

Then you get to the fun part of working with logs:

- Transformations to your logs during the pipeline phase
- Labelling your data
- Configuring your dashboards in Grafana
