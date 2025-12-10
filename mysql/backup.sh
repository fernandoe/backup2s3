#!/bin/bash

set -e

datetime_start=`python3 -c "import datetime; print(datetime.datetime.now())"`
time_start=`python3 -c "import time; print(time.time())"`
echo "Job started: ${datetime_start}"

WORKDIR=/backups/mysql
DATE=`date +%Y%m%d-%H%M`
ENVIRONMENT=${ENVIRONMENT:-development}
FILENAME_SQL=mysql-$ENVIRONMENT-${DB_DATABASE}-$DATE.sql
FILEPATH_SQL=$WORKDIR/$FILENAME_SQL
BUCKET=${BUCKET:-development}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-development}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-development}

echo "Validando diretórios necessários..."
mkdir -p "${WORKDIR}"

echo "Realizando o mysqldump..."
mysqldump -h${DB_HOST} -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE} > ${FILEPATH_SQL}

echo "Compactando o backup do banco.."
cd ${WORKDIR}
tar -zcvf ${FILENAME_SQL}.tar.gz ${FILENAME_SQL}

echo "Enviando arquivo para o S3 da AWS..."
resource="/${BUCKET}/mysql/${ENVIRONMENT}/${FILENAME_SQL}.tar.gz"
contentType="application/x-compressed-tar"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=${AWS_ACCESS_KEY_ID}
s3Secret=${AWS_SECRET_ACCESS_KEY}
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`

curl -X PUT -T "${FILENAME_SQL}.tar.gz" \
  -H "Host: ${BUCKET}.s3-us-west-2.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${s3Key}:${signature}" \
  https://${BUCKET}.s3-us-west-2.amazonaws.com/mysql/${ENVIRONMENT}/${FILENAME_SQL}.tar.gz

file_size_kb=`du -k "${FILENAME_SQL}.tar.gz" | cut -f1`
datetime_end=`python3 -c "import datetime; print(datetime.datetime.now())"`
time_time=`python3 -c "import time; start=${time_start}; elapsed=time.time() - start; print(\"%02d\" % elapsed)"`
echo "{\"version\": 1, \"information\": \"result\", \"size\": ${file_size_kb}, \"name\": \"${DB_DATABASE}\", \"start\": \"${datetime_start}\", \"end\": \"${datetime_end}\", \"time\": ${time_time}}"

echo "Removendo arquivos locais de backups..."
rm ${FILEPATH_SQL}
rm ${FILEPATH_SQL}.tar.gz

echo "Job finished: $(date)"
