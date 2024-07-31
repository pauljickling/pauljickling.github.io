---
layout: post
title: Debugging Misconfigured Container Networks
date: 2024-07-31
---
A common issue when debugging your container environment is you have a container application deployed to a particular port, say `3000`, and then you have another container running a reverse-proxy service so that it redirects HTTP traffic to HTTPS, and then serves up the content of your application running on port 3000. But when you check on your browser you encounter a 503 error.

The error you could be running into at this point is that you have your container network misconfigured. That can be discovered with the following command:

`docker ps --format "{{.Names}}\t{{.Networks}}"`

Note I am using docker here as the most familiar example, but it should work the same way if you use other container services like containerd or podman.

This will provide a list of the name of your deployed containers and what network they belong to.

If your deployed containers are on different networks, then they are isolated from one another. You can change that with the following command:

`docker network connect <network name> <container name>`

If you want to create a new network instead of an existing one you would do `docker network create <network name>` first.

Another issue that can happen during deployment is your container running the reverse proxy is unable to lookup the internal IP address of your application (possibly because they are running on different container networks!)

You can find a container's internal IP address with: `docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container name>`

In general, it's always good if you can apply some filters to a `docker inspect` query because by default you get a lengthy JSON file returned that can take awhile to find the relevant information you're looking for.

Now you should have an internal IP address for your application, something like, `172.17.0.2`. Now you can run `docker exec -it <reverse proxy container> /bin/bash` and the proceed to edit the container's config file. If you were using nginx-proxy you would look for the upstream block for your domain, and replace the `server` line with:

```
upstream <url> {
    server 172.17.0.2:3000;
}
```

Or a Caddyfile:

```
<url>

reverse_proxy :3000
```

After restarting the container you should be receiving content again.
