#!/bin/bash

# Get a list of all regions
regions=$(aws ec2 describe-regions --output json | jq -r '.Regions[].RegionName')

# Loop through each region
for region in $regions; do
    echo "Deleting stacks in region $region..."
    
    # Get a list of all stacks in the current region
    stacks=$(aws cloudformation list-stacks --region $region --output json | jq -r '.StackSummaries[].StackName')
    
    if [ -n "$stacks" ]; then
        for stack in $stacks; do
            # Delete the stack
            aws cloudformation delete-stack --stack-name $stack --region $region
            echo "Deleted stack $stack in region $region"
        done
    else
        echo "No stacks to delete in region $region"
    fi
done

echo "All CloudFormation stacks deleted in all regions."
