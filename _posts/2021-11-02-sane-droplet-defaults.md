---
layout: post
title: "Sane Droplet Defaults"
date: 2021-11-02
---

For quickly spinning up VMs on the cloud, Digitalocean provides a very simple deployment interface at a competitive price point. One annoyance with Digitalocean however is that the ssh access created is for the root user. This is not a good practice as you generally only want as much permission over a system as necessary to do a job, and root access gives you all the permissions. It is also a security vulnerability to allow root ssh access so it is better to disable it.

Although you could make these changes by logging in in the shell, it is pretty tedious, and easy to miss a step along the way. And if you have to do it across multiple VMs it becomes even more of a pain. Ansible was built for handling tasks like this with ease, so I'll show a sample role that could be used in a playbook for configuring Digitalocean droplets (their term for VMs) so that they are closer to the defaults you might see when you spin something up in AWS or Azure.

For the sake of brevity we'll skip the steps of installing Ansible and configuring your inventory. For the sake of this post, we'll assume you are at the step where the command `ansible -m ping all` returns a successful result, and you have a playbook where you have defined a role near the start of your playbook for reconfiguring your Digitalocean droplet.

The first task we'll want to do is create a new, non-root user. Our yaml file will start out like this:

```
- name: Create new user
  user:
    name: paul
    groups: admin,sudo
    password_lock: yes
    shell: /bin/bash
    state: present
```

Lets walk through this task line by line:

1. `- name: Create new user` is just Ansible user facing information when you are running the playbook. Although you don't technically need to include this, you definitely should because it will help you keep track of what Ansible does when you run it. So, like a git commit, you want your name to be a short, succinct explanation of what is going on.
2. `user:` This is telling Ansible to use the `user` module. If you ever want to find out how to use a module in Ansible, you can always just google `{name} ansible module` and you should be able to find an explanation quickly of how the module works. Although Ansible's documentation is great, searching the documentation is not so great in my experience, so I rely on google to find what I'm looking for usually. Note how the rest of the lines after this are indented, which indicates how everything else in this task is part of the user module.
3. `name: paul` Logically one of the first things we want to do with a new user is create a name for this user. It could be the name of the actual user, or maybe it will be something generic like `ubuntu` or something like that. Whatever it is, it will be defined here.
4. `groups: admin, sudo` Here we assign our new user to groups. In this hypothetical case, we want our new `paul` user to belong to the `admin` and `sudo` groups, presumably so this user can have sudo privileges. If you didn't want this you  skip this line, or define some other groups that make more sense for your user.
5. `password_lock: yes` This is equivalent to `usermod -L` which disables the use of a password for a user.
6. `shell: /bin/bash` By default, when you login as the user you will use the plain, old shell. This is a much less nice user experience compared to the bash shell, which has features like showing your present working directory, and autocomplete. It will also allow you to further customize your bash session by editing the `.bashrc` file in your home directory.
7. `state: present` Ansible has idempotent properties which is one of its main selling points over using a bash script to manage your servers. The `state` property allows us to define what should or should not exist in your system when you are running your playbooks. If we ever wanted to remove this user, we could simply change the state from `present`  to `absent`.

Now that we have created a new user on our server, we want to be able to ssh into the server as that user, so we need to supply the ssh public key in the `authorized_keys` file. Ansible has a specific module for just this task.

```
- name: Setup authorized_keys
  authorized_key:
    user: paul
    state: present
    key: '{{ item }}'
  with_file:
    - files/authorized_keys
```

Under the `key` property you can directly supply your pub key string if you'd like, but for the sake of readability I prefer to include it as a separate file since the strings are quite long. So we provide the `'{{ item }}' variable, which relies on the `with_file:` command to determine the public key. In this example we are assuming there is a `files` directory at the root of your ansible playbook that contains an `authorized_keys` file that contains your pub key. If we ever need to cycle out pub keys you can just update this file and rerun the playbook without touching any of the yaml files.

Another important thing we might want to configure is for our user to be able to use the `sudo` command. In this example we decided not to create a password for the user, so we will need to modify the `/etc/sudoers` file for that to be possible. Ansible's lineinfile module is great for modifying config files like this.

```
- name: Change and validate sudoers file
  lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%ADMIN ALL='
    line: '%ADMIN ALL=(ALL) NOPASSWD: ALL'
    validate: /usr/sbin/visudo -cf %s
```

Since our user is part of the admin group, we use a regular expression to search for the line in the config that begins with `ADMIN ALL=` and then we use the `line` command to specify `&ADMIN ALL=(ALL) NOPASSWD: ALL` which means that this user will always be able to use `sudo` without requiring a password.  If we know what that user needs root access for (for example, to run docker containers), it would be an even better idea to specify that rather than grant this broad permission. Finally, in the case of editing the sudoers file you want to validate your changes because bad things can happen if that file is improperly edited (if you were making these changes manually, you would normally use the `visudo` command rather than `vim` or `nano` to edit the file for this very reason). The `validate` command will do just that for this module.

We now have a user that we has ssh access and can use root commands as needed. The last step we want is to disable ssh root access. There are a couple of ways you could do this, but in my mind the most straight forward way is to edit the `sshd_config` file. Once again we can use the lineinfile module.

```
- name: Disable root ssh access
  lineinfile:
  path: /etc/ssh/sshd_config
  state: present
  regexp: '^PermitRootLogin'
  line: 'PermitRootLogin no'
```

With just a bit of extra work you now have a straight forward tool for configuring some sane defaults for your Digitalocean droplet.
