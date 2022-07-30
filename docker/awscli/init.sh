#!/bin/bash

SQS_ENDPOINT=http://sqs:9324
SQS_QUEUE_NAME=my-queue

DYNAMODB_ENDPOINT=http://dynamodb:8000
DYNAMODB_TABLE_NAME=my-table

S3_ENDPOINT=http://s3:9000
S3_BUCKET_NAME=my-bucket

QUEUES=`aws sqs list-queues \
  --queue-name-prefix ${SQS_QUEUE_NAME} \
  --query QueueUrls \
  --output text \
  --endpoint-url ${SQS_ENDPOINT}`

existsQueue=0

for queueUrl in ${QUEUES[@]}; do
  queueName=`echo ${queueUrl} | cut -f 5 -d "/"`
  if [ "${queueName}" = "${SQS_QUEUE_NAME}" ]; then
    existsQueue=1
    break
  fi
done

if [ "${existsQueue}" = "0" ]; then
  aws sqs create-queue \
    --queue-name ${SQS_QUEUE_NAME} \
    --endpoint-url ${SQS_ENDPOINT}
fi

TABLES=`aws dynamodb list-tables \
  --query TableNames \
  --output text \
  --endpoint-url ${DYNAMODB_ENDPOINT}`

existsTable=0

for tableName in ${TABLES[@]}; do
  if [ "${tableName}" = "${DYNAMODB_TABLE_NAME}" ]; then
    existsTable=1
    break
  fi
done

if [ "${existsTable}" = "0" ]; then
  aws dynamodb create-table \
    --table-name ${DYNAMODB_TABLE_NAME} \
    --attribute-definitions '[{"AttributeName":"id","AttributeType": "N"}]' \
    --key-schema '[{"AttributeName":"id","KeyType": "HASH"}]' \
    --billing-mode PAY_PER_REQUEST \
    --endpoint-url ${DYNAMODB_ENDPOINT}
fi

BUCKETS=`aws s3 ls | cut -f 3 -d " "`

existsBucket=0

for bucketName in ${BUCKETS[@]}; do
  if [ "${bucketName}" = "${S3_BUCKET_NAME}" ]; then
    existsBucket=1
    break
  fi
done

if [ "${existsBucket}" = "0" ]; then
  aws s3 mb s3://${S3_BUCKET_NAME} \
    --endpoint-url ${S3_ENDPOINT}
fi
