#!/bin/bash

S3_LOCATION=s3://[BUCKET_NAME]
FILE_NAME=kdattscalinglambda/index.zip

echo Zipping...
zip index.zip index.py

echo Copying to $S3_LOCATION/$FILE_NAME
aws s3 cp index.zip $S3_LOCATION/$FILE_NAME

echo Done
