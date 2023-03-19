# script creates a VPC with a CIDR block of 10.0.0.0/16, a subnet with a CIDR block of 10.0.1.0/24, and a security group that allows incoming SSH traffic from any IP 
# address (0.0.0.0/0). You may want to adjust these

import boto3

# create an EC2 client
ec2 = boto3.client('ec2')

# create a VPC
response = ec2.create_vpc(
    CidrBlock='10.0.0.0/16',
    InstanceTenancy='default'
)
vpc_id = response['Vpc']['VpcId']

# enable DNS support in the VPC
ec2.modify_vpc_attribute(
    VpcId=vpc_id,
    EnableDnsSupport={'Value': True}
)

# enable DNS hostnames in the VPC
ec2.modify_vpc_attribute(
    VpcId=vpc_id,
    EnableDnsHostnames={'Value': True}
)

# create a subnet in the VPC
response = ec2.create_subnet(
    CidrBlock='10.0.1.0/24',
    VpcId=vpc_id
)
subnet_id = response['Subnet']['SubnetId']

# create a route table in the VPC
response = ec2.create_route_table(
    VpcId=vpc_id
)
route_table_id = response['RouteTable']['RouteTableId']

# associate the subnet with the route table
ec2.associate_route_table(
    RouteTableId=route_table_id,
    SubnetId=subnet_id
)

# create a security group in the VPC
response = ec2.create_security_group(
    GroupName='MySecurityGroup',
    Description='My security group',
    VpcId=vpc_id
)
security_group_id = response['GroupId']

# allow incoming SSH traffic from a specific IP address
ec2.authorize_security_group_ingress(
    GroupId=security_group_id,
    IpPermissions=[
        {'IpProtocol': 'tcp',
         'FromPort': 22,
         'ToPort': 22,
         'IpRanges': [{'CidrIp': '0.0.0.0/0'}]}
    ]
)

# create a network ACL in the VPC
response = ec2.create_network_acl(
    VpcId=vpc_id
)
network_acl_id = response['NetworkAcl']['NetworkAclId']

# create a rule to allow incoming SSH traffic
ec2.create_network_acl_entry(
    NetworkAclId=network_acl_id,
    RuleNumber=100,
    Protocol='6',
    RuleAction='allow',
    Egress=False,
    CidrBlock='0.0.0.0/0',
    PortRange={'From': 22, 'To': 22}
)

# associate the network ACL with the subnet
ec2.associate_network_acl(
    NetworkAclId=network_acl_id,
    SubnetId=subnet_id
)

# disable internet access for the subnet
ec2.modify_subnet_attribute(
    MapPublicIpOnLaunch={'Value': False},
    SubnetId=subnet_id
)

print(f'VPC ID: {vpc_id}')
print(f'Subnet ID: {subnet_id}')
print(f'Route table ID: {route_table_id}')
print(f'Security group ID: {security_group_id}')
print(f'Network ACL ID: {network_acl_id}')
