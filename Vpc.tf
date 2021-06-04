provider "aws" {
  access_key = var.access_key 
  secret_key = var.secret_key 
  region     = var.region
}

resource "aws_vpc" "My_VPC_1" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  
tags = {
    Name = "My VPC 1"
}
} 

resource "aws_subnet" "My_VPC_Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  
tags = {
   Name = "My VPC Public Subnet "
}
}

resource "aws_subnet" "My_VPC_Public_Subnet_1" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = "us-east-1b"
  
tags = {
   Name = "My VPC Public Subnet 1"
}
}

resource "aws_subnet" "My_VPC_Private_Subnet_1" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
  
tags = {
   Name = "My VPC Private Subnet 1"
}
} 

resource "aws_subnet" "My_VPC_Private_Subnet_2" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1d"
  
tags = {
   Name = "My VPC Private Subnet 2"
}
} 

resource "aws_security_group" "My_VPC_Security_Group_1" {
  vpc_id       = aws_vpc.My_VPC_1.id
  name         = "My VPC Security Group 1"
  description  = "My VPC Security Group 1"
  
  
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group 1"
   Description = "My VPC Security Group"
}
} 

resource "aws_network_acl" "My_VPC_Security_ACL_1" {
  vpc_id = aws_vpc.My_VPC_1.id
  subnet_ids = [ aws_subnet.My_VPC_Public_Subnet.id, aws_subnet.My_VPC_Public_Subnet_1.id ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "My VPC ACL 1"
}
} 

resource "aws_internet_gateway" "My_VPC_GW_1" {
 vpc_id = aws_vpc.My_VPC_1.id
 tags = {
        Name = "My VPC Internet Gateway"
}
} 

resource "aws_route_table" "My_VPC_public_route_table" {
 vpc_id = aws_vpc.My_VPC_1.id
 tags = {
        Name = "My VPC Public Route Table"
}
} 

resource "aws_route_table" "My_VPC_private_route_table" {
 vpc_id = aws_vpc.My_VPC_1.id
 tags = {
        Name = "My VPC Private Route Table"
}
} 

resource "aws_route" "My_VPC_public_internet_access" {
  route_table_id         = aws_route_table.My_VPC_public_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW_1.id
} 

resource "aws_route_table_association" "My_VPC_public_association_1" {
  subnet_id      = aws_subnet.My_VPC_Public_Subnet.id
  route_table_id = aws_route_table.My_VPC_public_route_table.id
} 

resource "aws_route_table_association" "My_VPC_public_association_2" {
  subnet_id      = aws_subnet.My_VPC_Public_Subnet_1.id
  route_table_id = aws_route_table.My_VPC_public_route_table.id
} 

resource "aws_db_instance" "default" {
  allocated_storage = 20
  identifier = "testinstance"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  name = "test"
  username = "admin"
  password = "Admin12345"
  parameter_group_name = "default.mysql5.7"
}

resource "aws_subnet" "My_VPC_Private_Subnet_RDS1" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1e"
  
tags = {
   Name = "My VPC Private Subnet RDS 1"
}
} 

resource "aws_subnet" "My_VPC_Private_Subnet_RDS2" {
  vpc_id                  = aws_vpc.My_VPC_1.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1f"
  
tags = {
   Name = "My VPC Private Subnet RDS 2"
}
} 

resource "aws_db_subnet_group" "db_subnet" {
  name = "db subnet group"
  subnet_ids = [ aws_subnet.My_VPC_Private_Subnet_RDS1.id, aws_subnet.My_VPC_Private_Subnet_RDS2.id]
 }
 
 
