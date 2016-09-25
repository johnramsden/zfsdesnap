# zfsdesnap

Tool to destroy all ZFS snapshots before a certain date, based off name and date format +%Y-%m-%d-%H%M%S. Written in bourne shell.

## Usage

To use the script, call it with flag ```-p```, a prefix, ```-d``` and a specified date that snapshots should be destroyed before.

For example, to destroy all snapshots with the prefix "pre-install":

```shell
/usr/local/bin/zfsdesnap -p "pre-install" -d "$(date -d '1 week ago' +%Y-%m-%d-%H%M%S)"
```

## Commandline Flags

* ```-n``` Run in test mode, will not destroy anything.
* ```-a``` Ask before destroying snapshot.
* ```-p``` Running with a prefix.
* ```-r``` Run only on specified dataset.
* ```-d``` date snapshots should be destroyed before.

### systemd Units

To use with provided systemd units, move them into the location your system keeps user units in, most likely ```/etc/systemd/system```
