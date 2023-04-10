#!/bin/bash

# Define the list of users to be created
USERS=(
  "access-Arnav-peg-eng"
  "access-Mary-peg-qas"
  "access-Saanvi-uni-eng"
  "access-Carlos-uni-qas"
)

# Loop through each user and create them with tags and the access-assume-role permissions policy
for USER in "${USERS[@]}"
do
  echo "Creating user: $USER"
  aws iam create-user --user-name $USER
  aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AWSAccessKeys --user-name $USER
  aws iam tag-user --user-name $USER --tags Key=access-project,Value=$(echo $USER | cut -d'-' -f2) Key=access-team,Value=$(echo $USER | cut -d'-' -f3) Key=cost-center,Value=$(echo $USER | cut -d'-' -f4)
done
