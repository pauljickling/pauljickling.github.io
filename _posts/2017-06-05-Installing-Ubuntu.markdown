---
layout: post
title:  "Installing Ubuntu"
date:   2017-06-05
categories: Linux
---

Recently I've been interested in getting better acquainted with Ruby. However my experience by the time I reached Rails territory working in Windows was a miserable experience where nothing worked smoothly. Another recent occurrence was that I was in the market for a new laptop. Most Ruby people I know use Macs, but I've always bristled at the costs of a Macbook, and the reviews I've seen of the latest crop made me feel like I should stay away. So I decided it was time to get acquainted with a Linux OS. Since I'm a novice I decided it might be worth writing up how the installation process went.

There's a lot of different options with Linux. I went with Ubuntu just because it seemed like the most popular, and therefore it probably had the best support for a newcomer like myself. Perhaps not the most sophisticated consideration, but it's the truth! Also hey, free OS, so if I decided Ubuntu was a mistake it wouldn't cost me anything to try another.

[The instructions for creating a bootable USB stick](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows) were easy to follow, and didn't lead to any problems. Booting up the USB stick did provide complications thanks to some annoying Windows 10 settings. Initially the keys you would press to access the BIOS were disabled, and without without accessing BIOS I couldn't set the USB stick to a high enough boot priority.

After I resolved those issues the actual Ubuntu installation was fine. Unfortunately post-installation produced another major issue in the form of a "No Bootable Device Found" error message whenever I tried to startup the laptop without the USB stick. I found a [blog post](https://itsfoss.com/no-bootable-device-found-ubuntu/) with instructions for how to fix this error though.

After fixing that it was smooth sailing. Ubuntu's UI is clear and intuitive so I wasn't confused about how to get around. Navigating directories is different in the Windows terminal compared to the Linux terminal, but I got the hang of it after a few minutes. I downloaded my favorite code editor (Atom!) and the languages I was interested in working with, and I have been good to go. I also learned [the importance of the sudo command](https://en.wikipedia.org/wiki/Sudo).

All in all Ubuntu left a great first impression since I was anticipating a much more complicated and confusing experience.
