simple-backup
=============

A simple and useful shell script to backup mysql databases.

*This is NOT a backup system. Use only for simple tasks.*

## Configs

* `SB_DIRECTORY`: Main backup directory
    * Example: `/backup/sql`


* `SB_LOG_DIRECTORY`: Directory for log files
    * Example: `/backup/log`
    * Log files: `sb.log` and `sb_error.log`


* `SB_SEND_MAIL`: Boolean to send error mail
    * Default: `false`


* `SB_FILENAME`: Name of sqldump file
    * Default: `date +backup_%H`


* `SB_ZIP`: Program to compact sql files. Use `''` (empty) to **not** use.
    * Default: `bzip2`


* `SB_CLEAN_DAYS`: Number of days to keep files. All backup files will be deleted after the number of days.
    * Default: `7`


* `SB_MYSQL_BIN_FOLDER`: Mysql bin folder
    * Default: `''` (empty)

* `SB_MYSQL_HOST`: Mysql host address
    * Default: `localhost`


* `SB_MYSQL_USER`: Mysql user
    * Default: `backupuser`


* `SB_MYSQL_PASS`: Mysql password
    * Default: `password`


* `SB_MAIL_EMAIL`: Mail address who will receive the error mail
    * Example: `my@email.com`


* `SB_MAIL_SUBJECT`: Subject of the error mail
    * Default: `date +Backup\ Log\ %Y-%m-%d\ %Hh`
        * Example: `Backup Log 2014-10-01 10h`


## How to use

### Make it executable
    chmod +x simple-backup.sh


### Execute
    ./simple-backup.sh

### or ... Create a crontab
    00 00 * * * /home/directory/simple-backup.sh
