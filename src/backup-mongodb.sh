#!/usr/bin/env bash

# Editar a crontab com o camando:
# crontab -e
# Adicionar a linha abaixo arrumando o caminho para apontar corretamente o caminho do script
# @daily /home/ubuntu/backups/backup-mongodb.sh

# WORKDIR=/home/ubuntu/backups/mongodb
# DATE=`date +%Y%m%d-%H%M`
# ENVIRONMENT=staging
# FOLDER_NAME=edxapp-$ENVIRONMENT-mongodb-$DATE
# FOLDER_PATH=$WORKDIR/$FOLDER_NAME

# BUCKET=openedx-backup-staging



# echo "Realizando o mongodump..."
# mongodump -uadmin -ppassword --out ${FOLDER_PATH}



docker run --rm -v /tmp:/backup mongo:2.6.12 bash -c 'mongodump -uadmin -ppassword --host 172.31.37.121:27017 --out /backup'