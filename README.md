# wd-plexupdate
Script to automagically update Plex Media Server on Western Digital NAS (MyCloudOS)

This script will be very useful for you to automatically update your Plex Media Server installed on a Western Digital NAS.

## Prerequisites
 - [X] SSH Enabled
 - [X] ROOT Password
 - [X] Plex Media Server App already installed

## Compatibility and testing
| Model of WD NAS | MyCloudOS 3 |MyCloudOS 5|
|--|--|--|
| WD PR2100 | *No tested* |*No tested*  |
| WD PR4100 | *No tested* |  *Works*  |
| WD EX4100 | *No tested* |*No tested*  |
| WD EX2 Ultra | *No tested* |*No tested*  |
| WD Mirror | *No tested* |*No tested*  |
| WD DL2100 | *No tested* |*No tested*  |
| WD DL4100 | *No tested* |*No tested*  |
| WD Single Bay | *No tested* |*No tested*  |
| WD for Japon | *No tested* |*No tested*  |

# Installation instructions

## Copy script
You cannot use git clone to download this script directly from Western Digital NAS.

You can use wget to download RAW script from github:
`wget --no-check-certificate https://raw.githubusercontent.com/shadowmedicis/wd-plexupdate/main/plexupdate.sh`
or
You can therefore download directly from your computer to transfer it in SFTP / SMB.

Preferably place this script on your volume: "Volume_1" and in a folder only accessible by the admin user.

## File Permissions
Log into ssh as the sshd (root) user.
This script should be run as the root user, so it is important for security reasons to apply the necessary permissions.

`chown root:root plexupdate.sh`
`chmod 0700 plexupdate.sh`

## Scheduled task creation

We can use the `crontab -e` command to create the scheduled task.
If you are not comfortable with cron, you can use this site to help you: https://crontab-generator.org/

Exemple:
`0 3 * * * /shares/Volume_1/Scripts/plexupdate.sh > /shares/Volume_1/Scripts/Reports/cron-plexupdate-$(date +\%Y\%m\%d\%H\%M\%S).log &`

This example is a scheduled plex server update task every day at 3:00 a.m.
Logs of script output are also redirected day by day.

**Warning** Please note that your modifications in the crontab are not persistent.
Any modifications to the MyCloudOS system represent a risk. I advise you to carry out this action with full knowledge of the causes. To add the scheduled task on your system please use this tutorial: https://community.wd.com/t/how-to-make-persistent-system-changes-crontab-etc/201268

 ## Manual script execution
 
 Run this command in current path of the script:
`./plexupdate.sh`
 
![image](https://user-images.githubusercontent.com/80291786/119676468-28ff4580-be3e-11eb-9c75-b33b28e31a2b.png)



