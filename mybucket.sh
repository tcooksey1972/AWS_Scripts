# s3api service to create a variable that contains your bucket name replace 'notes-bucket' with the string of the bucket you wish to assign as myBucket

mybucket=$(aws s3api list-buckets --output text --query 'Buckets[?contains(Name, `notes-bucket`) == `true`].Name')
