#!/bin/bash

#source http://002.yaha.me/item/22728a58-c967-46d5-93eb-2649d684a9aa/

MYSQL_USER="yourname"
MYSQL_HOST="localhost"
MYSQL_PASSWORD="yourpassword"
MYSQL_BIN="$(which mysql)"
MYSQLDUMP_BIN="$(which mysqldump)"

STORE_FOLDER="."

TODAY=$(date +"%Y-%m-%d")
DAILY_DELETE_NAME="daily-"`date +"%Y-%m-%d" --date '3 days ago'`
WEEKLY_DELETE_NAME="weekly-"`date +"%Y-%m-%d" --date '3 weeks ago'`
MONTHLY_DELETE_NAME=`date +"%Y-%m-%d" --date '3 months ago'`

for db in 'db_name_1' 'db_name_2' 'db_name_3'
do
  THE_PATH=$STORE_FOLDER/$db
  echo  $DAILY_DELETE_NAME
  if [ ! -d "$THE_PATH" ]; then
    mkdir -p "$THE_PATH"
  fi
  echo $THE_PATH/$DAILY_DELETE_NAME.sql.gz
  rm -rf $THE_PATH/$DAILY_DELETE_NAME.sql.gz
  rm -rf $THE_PATH/$WEEKLY_DELETE_NAME.sql.gz
  rm -rf $THE_PATH/$MONTHLY_DELETE_NAME.sql.gz

  #daily
  $MYSQLDUMP_BIN -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASSWORD $db | gzip -9 > $THE_PATH/daily-$TODAY.sql.gz

  #weekly
  if [ `date +%u` -eq 7 ];then
    cp $THE_PATH/daily-$TODAY.sql.gz $THE_PATH/weekly-$TODAY.sql.gz
  fi

  #monthly
  if [ `date +%d` -eq 25 ];then
    cp $THE_PATH/daily-$TODAY.sql.gz $THE_PATH/monthly-$TODAY.sql.gz
  fi
done