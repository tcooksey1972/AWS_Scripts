#!/bin/bash

# get all bucket names
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# loop through each bucket and delete it
for bucket in $buckets
do
    aws s3 rb s3://$bucket --force
done
