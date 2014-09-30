#!/bin/sh
# simple-backup | https://github.com/nops/simple-backup
#title        :simple-backup.sh
#description: :Main file
#author       :nops <https://github.com/nops>
#version      :0.1

source config.cfg

SB_TIME=`date`

echo 'Starting backup: '$SB_TIME

source clean.sh

if [ ! -d "$SB_DIRECTORY" ]; then
    echo 'Creating directory: '$SB_DIRECTORY
    mkdir "$SB_DIRECTORY"
fi

cd "$SB_DIRECTORY"

databases=`mysql -u $SB_MYSQL_USER -p$SB_MYSQL_PASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [ "$db" != "information_schema" ] && [ "$db" != _* ]; then
        echo "Dumping database: $db"
        mysqldump -u $SB_MYSQL_USER -p$SB_MYSQL_PASS --databases $db | bzip2 > $SB_FILENAME.$db.sql.bz2 2> $SB_EFILE
    fi
done

if [ -s "$SB_EFILE" ]; then
    echo 'Error on backup. Check log: '$SB_EFILE
fi

SB_TIME=`date`

echo 'Backup ended: '$SB_TIME
