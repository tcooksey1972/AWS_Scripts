#!/bin/bash

# Get list of all resources
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text > instances.txt
aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier' --output text > rds.txt
aws s3api list-buckets --query 'Buckets[].Name' --output text > buckets.txt

# Terminate all EC2 instances
while read instance_id; do
  aws ec2 terminate-instances --instance-ids $instance_id
done < instances.txt

# Delete all RDS instances
while read rds_id; do
  aws rds delete-db-instance --db-instance-identifier $rds_id --skip-final-snapshot
done < rds.txt

# Delete all S3 buckets
while read bucket_name; do
  aws s3 rb s3://$bucket_name --force
done < buckets.txt

# Clean up other resources (e.g. EBS volumes, EFS file systems, etc.)
# ...

# Delete all CloudFormation stacks
aws cloudformation delete-stack --stack-name <stack-name> --region <region> --capabilities CAPABILITY_NAMED_IAM

# Delete all Elastic Beanstalk environments
aws elasticbeanstalk describe-environments --query 'Environments[].EnvironmentName' --output text | xargs -I % aws elasticbeanstalk terminate-environment --environment-name %

# Delete all Lambda functions
aws lambda list-functions --query 'Functions[].FunctionName' --output text | xargs -I % aws lambda delete-function --function-name %

# Delete all API Gateway APIs
aws apigateway get-rest-apis --query 'items[].id' --output text | xargs -I % aws apigateway delete-rest-api --rest-api-id %

# Delete all IAM resources (users, roles, policies, etc.)
aws iam list-users --query 'Users[].UserName' --output text | xargs -I % aws iam delete-user --user-name %
aws iam list-roles --query 'Roles[].RoleName' --output text | xargs -I % aws iam delete-role --role-name %
aws iam list-policies --query 'Policies[].PolicyName' --output text | xargs -I % aws iam delete-policy --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/%
aws iam list-instance-profiles --query 'InstanceProfiles[].InstanceProfileName' --output text | xargs -I % aws iam delete-instance-profile --instance-profile-name %

# Reset all configuration to default
aws configure set default.region us-east-1
aws configure set default.output json

# Clean up local files
rm instances.txt rds.txt buckets.txt
