#command below to enables Amazon S3 website hosting
aws s3api put-bucket-website --bucket $mybucket --website-configuration file://~/environment/labRepo/website.json
