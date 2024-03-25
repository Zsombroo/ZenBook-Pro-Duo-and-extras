# ZenBook-Pro-Duo-install-guide

I wrote this guide for myself in case I ever decide to reinstall my ZenBook Pro Duo. Most information you can find here are from online forums, documentations and video guides. FYI I am using wayland.

## Open questions

### How to get real cpu temp?

There is an Intel digital thermal sensor with loaded 'coretemp' driver.

    sudo dnf install lm_sensors
    sensors

lm-sensors however reports guessed temperature based on the load, therefore it is not the real temperature of the cpu. Is there a way to see the real cpu temp?

## Installing Fedora 39

Special buttons work out of the box. Brightness, keyboard backlight, volume control, screenshot etc.

Asus laptop specific buttons such as MyAsus, fan control, display switch, turn off secondary display buttons however do not work. I don't really need these, so I did not look up how they could be fixed.

I have two ZenBooks:
- UX582HS (i9, 32GB ram)
- UX582LR (i7, 16GB ram)

None of them have sound by default. UX582LR can be fixed running the following commands after boot in terminal.

    sudo dnf install alsa-tools

Then either

    sudo hda-verb /dev/snd/hwC0D0 0x20 0x500 0xf
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x400 0x7774
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x500 0x45
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x400 0x5289

or

    sudo hda-verb /dev/snd/hwC0D0 0x20 0x500 0x1b
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x477 0x4a4b
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x500 0xf
    sudo hda-verb /dev/snd/hwC0D0 0x20 0x477 0x74

will solve the sound issue. You will have to run these four lines after every reboot. Here is post about the issue

https://www.spinics.net/lists/alsa-devel/msg154810.html

I also saved it in the Wayback Machine just in case

https://web.archive.org/web/20240324193414/https://www.spinics.net/lists/alsa-devel/msg154810.html

**Unfortunatelly this did not work for me with the UX582HS laptop. If you know the solution, please raise an issue under this repository.**

## Battery charging threshold

Confirm that your system finds BAT* (BAT0 in my case) under the following path

    ls /sys/class/power_supply

You should have the following file by default

    ll /sys/class/power_supply/BAT0/charge_control_end_threshold

It should only contain the number 100. This is the threshold. With the default windows installation on a Zenbook Pro Duo, Asus sets the charging threshold to 60% if you choose the maximum battery life option in the MyAsus configurations. For this reason I always set this value to 60 as well.

This value needs to be set after every reboot, so create a systemd service that runs automatically

/etc/systemd/system/battery-charge-threshold.service

    [Unit]
    Description=Set the battery charge threshold
    After=multi-user.target
    StartLimitBurst=0

    [Service]
    Type=oneshot
    Restart=on-failure
    ExecStart=/bin/bash -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

    [Install]
    WantedBy=multi-user.target

Then start and enable the service

    systemctl start battery-charge-threshold.service
    systemctl enable battery-charge-threshold.service

## Secondary screen brightness

You can control the secondary screen brightness with brightnessctl

    sudo dnf install brightnessctl

Listing the devices

    brightnessctl --list

    Device 'intel_backlight' of class 'backlight':
        Current brightness: 268 (51%)
        Max brightness: 528

    Device 'asus_screenpad' of class 'backlight':
        Current brightness: 62 (26%)
        Max brightness: 235

The 'asus_screenpad' device is the secondary screen. To change the brightness, use the following command

    brightnessctl -d asus_screenpad set 100%

## Nvidia drivers

The following site has a guide on how to install nvidia proprietary driver instead of the nouveau driver

    https://asus-linux.org/guides/fedora-guide/

## Fan speed control

Fan speed can be controlled through the following file

    /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/pwm1_enable

- 2 means fan speed is set to auto control
- 0 means full speed

## System monitoring

I mainly user btop for this task.

Another option to monitor the cpu:

    sudo dnf install s-tui
    s-tui

This shows temperature, frequency, utilization and cpu fan rpm. It can also stress test the cpu.