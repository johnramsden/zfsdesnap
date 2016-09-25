# zfsdesnap

Tool to destroy all ZFS snapshots before a certain date, based off name and date format +%Y-%m-%d-%H%M%S. Written in bourne shell.

## Usage

To use the script, call it with a specified date that all snapshots should be destroyed before. Optionally a specific dataset can be given with ```-d``` and prefix with ```-p```.

For example, to destroy all snapshots with the prefix "pre-install":

```shell
zfsdesnap -p "pre-install" -d "$(date -d '1 week ago' +%Y-%m-%d-%H%M%S)"
```

## Commandline Flags

* ```-p``` Running with a prefix.
* ```-d``` Date snapshots should be destroyed before.
* ```-n``` (Optional) Run in test mode, will not destroy anything.
* ```-a``` (Optional) Ask before destroying snapshot.
* ```-r``` (Optional) Run only on specified dataset.

### systemd Units

To use routinely with the provided systemd units, move them into the location your system keeps user units in, most likely ```/etc/systemd/system```.

Next specify each prefix you would like to be delete and start or enable the timer.

So for the prefix "pre-install":

```shell
systemctl enable zfsdesnap-week@pre-install.timer
```

There are provided units for snapshots a week, ```zfsdesnap-week@```, month ```zfsdesnap-month@```, and year ```zfsdesnap-year@``` old.
