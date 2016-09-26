# zfsdesnap

Tool to destroy all ZFS snapshots before a certain date, based off a configurable name and date format. Written in bourne shell.

## Usage

To use the script, name snapshots in the format ```zpool@${prefix}-$(date +%Y-%m-%d-%H%M%S)```, then call ```zfsdesnap``` with a specified date that all snapshots should be destroyed before. Optionally a specific dataset can be given with ```-d```, prefix with ```-p```, and with ```-f``` the format of date to look for can be changed.

### Examples

Destroy all snapshots with the prefix "pre-install" that are over a week old.

```shell
zfsdesnap -p "pre-install" -d "$(date -d '1 week ago' +%Y-%m-%d-%H%M%S)"
Running in test mode, will not destroy anything
Running with prefix: pre-install
Date: 2016-09-18-171206
2016-09-18-171206
Date 2016-09-18-171206 accepted
Destroy before date was set to 2016-09-18-171206
Removing hyphens
Destroydate: 20160918171206
Running on all datasets
```

Too use a different date format it can be specified. To change the date removing minutes and seconds set the format from the default ```[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{6}``` to ```[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{4}```. This describes the digits to look for.

For example, to specify older than a week ago in format year-month-day:

```shell
zfsdesnap -p "pre-install" -d "$(date -d '1 week ago' +%Y-%m-%d)" -f "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}"
Running in test mode, will not destroy anything
Running with prefix: pre-install
Date: 2016-09-18
Date format: [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}
2016-09-18
Date 2016-09-18 accepted
Destroy before date was set to 2016-09-18
Removing hyphens
Destroydate: 20160918
Running on all datasets
```

Run in test mode, list all snapshots with the prefix "pre-ins" that are in the dataset
 ```tank/home``` and were made with date "2016-06-07-155650"

```shell
zfsdesnap -n -p "pre-ins" -r "tank/home" -d "2016-06-07-155650"
```

## Commandline Flags

* ```-p``` Running with a prefix.
* ```-d``` Date snapshots should be destroyed before.
* ```-n``` (Optional) Run in test mode, will not destroy anything.
* ```-a``` (Optional) Ask before destroying snapshot.
* ```-r``` (Optional) Run only on specified dataset.
* ```-f``` (Optional) Set format of date.
### systemd Units

To use routinely with the provided systemd units, move them into the location your system keeps user units in, most likely ```/etc/systemd/system```.

Next specify each prefix you would like to be delete and start or enable the timer.

So for the prefix "pre-install":

```shell
systemctl enable zfsdesnap-week@pre-install.timer
```

There are provided units for snapshots a week, ```zfsdesnap-week@```, month ```zfsdesnap-month@```, and year ```zfsdesnap-year@``` old.
