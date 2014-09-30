#!/bin/sh
# simple-backup | https://github.com/nops/simple-backup
#title        :clean.sh
#description: :Delete old files from backups
#author       :nops <https://github.com/nops>
#version      :0.1

source config.cfg

SB_TIME=`date`

echo 'Starting cleaning: '$SB_TIME

cd "$SB_DIRECTORY"

echo 'Deleting files with more than '$SB_CLEAN_DAYS' days'

find * -ctime +$SB_CLEAN_DAYS -exec rm -rf {} \;

SB_TIME=`date`

echo 'Clean ended: '$SB_TIME
