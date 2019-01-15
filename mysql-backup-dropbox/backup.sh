#!/bin/sh

set -eu

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
databases=$(mysql $MYSQL_HOST_OPTS -e 'SHOW DATABASES;' --silent)

NOW=$(date +"%m-%d-%Y-%S")
echo "now $NOW"
for database in $databases
do
  if [ "$database" != "information_schema" ]
  then
    echo "Creating backup for $database..."
    filename="$database.$NOW"
    mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS  $database > $filename.sql
    gzip $filename.sql
    curl -X POST https://content.dropboxapi.com/2/files/upload \
              --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
              --header "Dropbox-API-Arg: {\"path\": \"/$DROPBOX_PREFIX/$filename.sql.gz\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" \
              --header "Content-Type: application/octet-stream" \
              --data-binary @$filename.sql.gz
    rm $filename.sql.gz

  fi
done

