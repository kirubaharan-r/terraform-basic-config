terraform {
   backend "s3"{
    bucket = "state-tf-test"
    region="eu-west-2"
    key="state-files/main.tfstate"
    dynamodb_table = "tf-statelock-file"
   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}


provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Test   = "test-vpc-&Aurora-&EKS-demo"
      region = "eu-west-1"
    }
  }
}

# creates new VPC
resource "aws_vpc" "vpc-test" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
}

# creates Intetnet gateway

resource "aws_internet_gateway" "vpc-test-igw" {
  vpc_id = aws_vpc.vpc-test.id

}

# creates EIP for NAT gateway

#resource "aws_eip" "eips" {

#}

# Creates Public subnets

resource "aws_subnet" "az1" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "az2" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "az3" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true
}

# creates nat gateway

# resource "aws_nat_gateway" "vpc-test-nat-gw" {
#   subnet_id     = aws_subnet.az1.id
#   allocation_id = aws_eip.eips.id
# }

# Creates Private subnets

resource "aws_subnet" "az1-priv" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.4.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "az2-priv" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.5.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "az3-priv" {
  vpc_id                  = aws_vpc.vpc-test.id
  cidr_block              = "10.10.6.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true
}

# Creates route table for Public subnets
resource "aws_route_table" "vpc-test-rt" {
  vpc_id = aws_vpc.vpc-test.id
}
# attach the internet gateway public routes
resource "aws_route" "routes" {
  route_table_id         = aws_route_table.vpc-test-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-test-igw.id

}
resource "aws_route_table_association" "vpc-test-az-a" {
  subnet_id      = aws_subnet.az1.id
  route_table_id = aws_route_table.vpc-test-rt.id

}
resource "aws_route_table_association" "vpc-test-az-b" {
  subnet_id      = aws_subnet.az2.id
  route_table_id = aws_route_table.vpc-test-rt.id

}
resource "aws_route_table_association" "vpc-test-az-c" {
  subnet_id      = aws_subnet.az3.id
  route_table_id = aws_route_table.vpc-test-rt.id

}

# Creates route table for Public subnets

resource "aws_route" "routes-main" {
  route_table_id         = aws_vpc.vpc-test.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-test-igw.id
}
resource "aws_route_table_association" "vpc-test-az-c-priv" {
  subnet_id      = aws_subnet.az3-priv.id
  route_table_id = aws_vpc.vpc-test.main_route_table_id

}
resource "aws_route_table_association" "vpc-test-az-b-priv" {
  subnet_id      = aws_subnet.az2-priv.id
  route_table_id = aws_vpc.vpc-test.main_route_table_id

}
resource "aws_route_table_association" "vpc-test-az-a-priv" {
  subnet_id      = aws_subnet.az1-priv.id
  route_table_id = aws_vpc.vpc-test.main_route_table_id
}