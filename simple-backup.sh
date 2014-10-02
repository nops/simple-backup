#!/bin/sh
# simple-backup | https://github.com/nops/simple-backup
#title        :simple-backup.sh
#description: :Main file
#author       :nops <https://github.com/nops>
#version      :0.2

source config.cfg

SB_TIME=`date`

SB_LOG=$SB_LOG_DIRECTORY'/sb.log'

SB_EFILE=$SB_LOG_DIRECTORY'/sb_error.log'

if [ ! -d "$SB_LOG_DIRECTORY" ]; then
    mkdir "$SB_LOG_DIRECTORY"
    touch $SB_LOG
    touch $SB_EFILE
    echo 'Creating directory: '$SB_DIRECTORY >> $SB_LOG
fi

if [ ! -f "$SB_LOG" ]; then
    touch $SB_LOG
fi

if [ ! -f "$SB_EFILE" ]; then
    touch $SB_EFILE
fi

echo 'Starting backup: '$SB_TIME >> $SB_LOG

source clean.sh

if [ ! -d "$SB_DIRECTORY" ]; then
    echo 'Creating directory: '$SB_DIRECTORY >> $SB_LOG
    mkdir "$SB_DIRECTORY"
fi

cd "$SB_DIRECTORY"

if [ $SB_MYSQL_BIN_FOLDER != '' ]; then
    export PATH=$SB_MYSQL_BIN_FOLDER:$PATH
fi

databases=`mysql -u $SB_MYSQL_USER -p$SB_MYSQL_PASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [ "$db" != "information_schema" ] && [ "$db" != _* ]; then
        echo "Dumping database: $db" >> $SB_LOG
        if [ $SB_ZIP = '' ]; then
            mysqldump -h $SB_MYSQL_HOST -u $SB_MYSQL_USER -p$SB_MYSQL_PASS --databases $db > $SB_FILENAME.$db.sql 2> $SB_EFILE
        else
            mysqldump -h $SB_MYSQL_HOST -u $SB_MYSQL_USER -p$SB_MYSQL_PASS --databases $db | $SB_ZIP > $SB_FILENAME.$db.sql.bz2 2> $SB_EFILE
        fi
    fi
done

if [ -s "$SB_EFILE" ]; then
    echo 'Error on backup. Check log: '$SB_EFILE >> $SB_LOG
    if [ $SB_SEND_MAIL -eq true ]; then
        echo 'Sending email to: '$SB_MAIL_EMAIL >> $SB_LOG
        cat $SB_EFILE | mail -s $SB_MAIL_SUBJECT $SB_MAIL_EMAIL
    fi
else
    echo 'Successful backup' >> $SB_LOG
fi

SB_TIME=`date`

echo 'Backup ended: '$SB_TIME >> $SB_LOG
