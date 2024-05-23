# Install services

Run this in a terminal to copy the required files

```bash
sudo cp bt_bind*.service /lib/systemd/system
```

Then to enable/update required services (bluetooth) do the following:

First edit the bluetooth service:
```bash
sudo nano /etc/systemd/system/dbus-org.bluez.service
```

Modify/Add the lines below:
```bash
ExecStart=/usr/sbin/bluetoothd -C --noplugin=sap
ExecStartPost=/usr/bin/sdptool add SP
```
Then restart the bluetooth services
```bash
sudo systemctl daemon-reload
sudo rfkill block bluetooth
sudo rfkill unblock bluetooth
sudo systemctl stop bluetooth.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo systemctl enable dbus-org.bluez.service
sudo systemctl restart dbus-org.bluez.service
```
Restart the system
sudo reboot

# Pair devices

Run the Bluetooth controller:
```bash
sudo bluetoothctl
```
You will see a prompt like this: `[bluetooth]#`

Copy this commands to enable Bluetooth and start scanning
```bash
power on
system-alias ‘Farmerin’
scan on
```
You will see some new devices, note those that will be connected later. In this case these devices are name0 and name1 (with mac0 and mac1)
```bash
...
[NEW] Device <mac0> <name0>
...
[NEW] Device <mac1> <name1>
...
```

Now pair and trust those devices.
```bash
pair <mac0>
PIN 0000
trust <mac0>
pair <mac1>
PIN 0000
trust <mac1>
```

Once finished stop the scanner
```bash
scan off
```

Now exit the controller with `CTRL+D`

# Bind devices to rfcommX
```bash
# To enable binding of device 0 with mac0
sudo systemctl enable bt_bind0@<mac0>.service
sudo systemctl start bt_bind0@<mac0>.service

# To enable binding of device 1 with mac1
sudo systemctl enable bt_bind0@<mac0>.service
sudo systemctl start bt_bind1@<mac1>.service
```

You should see the binded devices as /dev/rfcommX:
```bash
ls /dev/rfcomm*
```

Now you can open a serial terminal and test:
```bash
picocom -b 9600 /dev/rfcomm0
```
