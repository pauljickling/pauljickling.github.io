---
layout: post
title: "Target Labels in Prometheus"
date: 2023-03-14
---

The primary use-case for labels in Prometheus is to add extra information to the metrics you are collecting, which allows you to filter and aggregate your metrics in useful ways. But you can also create target labels for your Prometheus sources. This is useful because the default label for a target is just going to be its IP address and port number. Typically, you would rather have a human friendly name for your Prometheus source. Adding labels to targets is a very straight forward process unlike managing actual label metrics, which can introduce a cardinality explosion to your Prometheus application (that is where adding a bunch of extra labels create an enormous amount of memory overhead and causes Prometheus to crash). However despite the straight forward nature of adding target labels, it isn't easy to find a simple reference to it in the Prometheus docs, hence this blog post.

Lets suppose you are running Node Exporter on your web app, and want to expose that data to Prometheus. You could write your Prometheus config in this way:

```
scrape_configs:
  # Node exporter metrics
  - job_name: "node_exporter"
    static_configs:
    - targets: ["{{ ip_address }}:9100"]
      labels:
        instance: "web app VM"
```

What this config does is it looks at the array/list defined by your `targets` and applies the instance label to every item contained there.

If you're using Ansible to configure your Prometheus configuration you can take advantage of Jinja templating to make your configuration file more extensible. Lets say instead of wanting to collect the node exporter metrics for a single VM, you wanted to collect the data for an entire collection of servers managed by your Ansible playbook, you could rewrite your configuration this way:

```
scrape_configs:
  # Node exporter metrics
  - job_name: "node_exporter"
  static_configs:
  {% for host in groups['all'] %}
- targets: ["{{ hostvars[host]['ansible_host'] }}:9100"]
      labels:
        instance: {{ host }}
  {% endfor %}
```

In this case we loop through the entire ansible inventory (if you only wanted to collect metrics for a subset of your inventory, you would instead define that group, and specify that in your groups instead of `groups['all']`) and use the value of `host` to label the target.

One thing you would want to be careful for with this technique is when you use jinja's templating to format your yaml sometimes the spacing might not quite be what you expect it to look like, and this can potentially break or lead to bugs with your config file. Luckily the ansible template module has a pretty simple way to check the output of a template file.

```
tasks:
- name: review template
  check_mode: true
  diff: true
  template:
    src: "{{ path/to/config template }}"
    dest: "output.yml"
```

In cases where I want to check my work, I'll typically write a small, separate playbook that looks something like the above as a quick sanity check before running the actual playbook that will make the actual configuration changes.
