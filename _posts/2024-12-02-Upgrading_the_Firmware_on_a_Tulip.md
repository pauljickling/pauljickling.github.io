---
layout: post
date: 2024-12-02
title: "Upgrading the Firmware on a Tulip"
---
The [Tulip computer](https://tulip.computer) is a cool, tiny device that provides a simple Pythyon IDE hooked up to music synth library that allows you to write scripts that generate music programmatically. I love small form factor devices like this that are incredibly expressive and user friendly. The device is also receiving regular updates, so it is getting better all the time.

However, doing your initial upgrade when you first receive the device can require clearing a few hurdles. Normally the device runs upgrades by connecting to wifi, so you run `tulip.wifi('ssid', 'password')`, and then `tulip.upgrade()`. However, due to a limitation of the initial implementation, the wifi library doesn't like security certs like WPA2/3. More recent versions support this, but of course that doesn't do you any good if you can't connect your device to the internet to perform an upgrade in the first place. In that case you need to download the latest release from GitHub and flash it to the device.

Flashing to the device is straightforward enough with a tool like esptool.py... except that if you are on a recent MacOS version it requires a driver that Apple doesn't like. In theory you should be able to update permissions so allow it, but I couldn't personally get it to cooperate. (**Update:** There are now instructions on how to run the driver on Macs running Sequoia. You can find instructions [here](https://github.com/WCHSoftGroup/ch34xser_macos/issues/27#issuecomment-2524266376))

Luckily there is computing beyond the world of Apple's walled gardens, running esptool on most Linux devices should just work™. After connecting the Tulip to a Rasberry Pi I had handy, I installed esptool, `wget` the binary, and ran `esptool.py write_flash 0x0 <tulip release>.bin`, and it got going. After it finished flashing the Tulip, I removed it, plugged a keyboard in (I don't recommend plugging in the Tulip with a keyboard attached to it while doing the flash, the power draw is going to be too great for most pis), and was able to successfully connect to the wifi! At that point I didn't really need to run `tulip.upgrade()`, but did anyway just to see it in action.
