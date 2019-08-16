---
layout: post
title: "How to configure your Yubikey to unlock KeePassXC"
tags: security
excerpt: "Before using your Yubikey to authorise changes to your Password database, make sure you own at least two Yubikeys. Those keys are phyiscal objects that can get lost, stolen or broken so it is vital to own a backup key."
---

<div class="note">
Before using your Yubikey to authorise changes to your Password database, make sure you own at least two Yubikeys. Those keys are phyiscal objects that can get lost, stolen or broken so it is vital to own a backup key.<br/><br/>

If you own a Yubikey version 4 or above there are 2+ slots available. The first slot is configured to authorize against the Yubico Cloud, so it's propably a good idea to not overwrite this Slot as to not loose access to this functionality.
</div>

## Yubico Yubikey Personalization Tool

![](https://blobscdn.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-Lm99kJJMjzmav6sV_xV%2F-LmF0Gk3gimdRkImc-Kc%2F-LmF1qKZmTRjzsiiCAsJ%2FScreenshot%202019-08-14%20at%2014.10.45.png?alt=media&token=98a5639d-6ba7-40e2-8f39-567d84542fb9)

- Download the Yubico Yubikey Personalization Tool and install it.

- Open the Personalization Tool.

- Insert the first Yubikey into a free USB slot.

- Select the Tab Challenge-Response in the top part of the window.

- Choose HMAC-SHA1 

- Select Configuration Slot 2.

- Deselect Program Multiple Yubikeys

- Klick on Require user input (button press)

- Select the HMAC-SHA1 Mode to be Fixed 64 byte input

- Click Generate

- Save the Secret Key somewhere. This will allow you to program additional keys later on. Make sure to properly select all bytes when copy-pasting the value.

- Last but not least, press Write Configuration

- Repeat step 9 for every yubikey.

## KeePassXC

- Open and unlock the database you want to protect with Yubikey protection

- Select Database -> Database settings in the menu.

- Choose the the Tab "Security"

- Choose the option "Add additional protection".

- Choose Yubikey Challenge-Response and follow the on-screen instructions.

