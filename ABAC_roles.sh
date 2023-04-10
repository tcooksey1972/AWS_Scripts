# Role 1: access-peg-engineering
aws iam create-role \
  --role-name access-peg-engineering \
  --description "Allows engineers to read all engineering resources and create and manage Pegasus engineering resources." \
  --tags Key=access-project,Value=peg Key=access-team,Value=eng Key=cost-center,Value=987654

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/access-same-project-team \
  --role-name access-peg-engineering

# Role 2: access-peg-quality-assurance
aws iam create-role \
  --role-name access-peg-quality-assurance \
  --description "Allows the QA team to read all QA resources and create and manage all Pegasus QA resources." \
  --tags Key=access-project,Value=peg Key=access-team,Value=qas Key=cost-center,Value=987654

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/access-same-project-team \
  --role-name access-peg-quality-assurance

# Role 3: access-uni-engineering
aws iam create-role \
  --role-name access-uni-engineering \
  --description "Allows engineers to read all engineering resources and create and manage Unicorn engineering resources." \
  --tags Key=access-project,Value=uni Key=access-team,Value=eng Key=cost-center,Value=123456

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/access-same-project-team \
  --role-name access-uni-engineering

# Role 4: access-uni-quality-assurance
aws iam create-role \
  --role-name access-uni-quality-assurance \
  --description "Allows the QA team to read all QA resources and create and manage all Unicorn QA resources." \
  --tags Key=access-project,Value=uni Key=access-team,Value=qas Key=cost-center,Value=123456

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/access-same-project-team \
  --role-name access-uni-quality-assurance
