# VPC RESOURCE
resource "aws_vpc" "mobikart-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mobikart-vpc"
  }
}

# PUBLIC SUBNET RESOURCE
resource "aws_subnet" "public-mobikart-SN" {
  vpc_id                  = aws_vpc.mobikart-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-mobikart-SN"
  }
}

# PUBLIC SUBNET RESOURCE
resource "aws_subnet" "public-mobikart-SN2" {
  vpc_id                  = aws_vpc.mobikart-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-mobikart-SN2"
  }
}

# Create Private Subnet1
resource "aws_subnet" "private-mobikart-SN1" {
  vpc_id            = aws_vpc.mobikart-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "private-mobikart-SN1"
  }
}

resource "aws_subnet" "private-mobikart-SN2" {
  vpc_id            = aws_vpc.mobikart-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "private-mobikart-SN2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "mobikart-IGW" {
  vpc_id = aws_vpc.mobikart-vpc.id

  tags = {
    "Name" = "mobikart-IGW"
  }

}

# Allocate Elastic IP Address for Nat-Gateway
resource "aws_eip" "mobikart-NAT-EIP" {
  vpc = true

  tags = {
    "Name" = "mobikart-NAT-EIP"
  }

}

# Create Nat Gateway
resource "aws_nat_gateway" "mobikart-NAT" {
  allocation_id = aws_eip.mobikart-NAT-EIP.id
  subnet_id     = aws_subnet.public-mobikart-SN.id

  tags = {
    "Name" = "mobikart-NAT"
  }

}

# Create Private Route Table and configure route
resource "aws_route_table" "private-mobikart-RT" {
  vpc_id = aws_vpc.mobikart-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mobikart-NAT.id
  }

  tags = {
    "Name" = "private-mobikart-RT"
  }

}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private-mobikart-SN1-association" {
  subnet_id      = aws_subnet.private-mobikart-SN1.id
  route_table_id = aws_route_table.private-mobikart-RT.id
}
resource "aws_route_table_association" "private-mobikart-SN2-association" {
  subnet_id      = aws_subnet.private-mobikart-SN2.id
  route_table_id = aws_route_table.private-mobikart-RT.id
}

# Create Public Route Table and Configure Route
resource "aws_route_table" "public-mobikart-RT" {
  vpc_id = aws_vpc.mobikart-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mobikart-IGW.id
  }

  tags = {
    "Name" = "public-mobikart-RT"
  }

}

# Associate Public Route Table with Public subnet 
resource "aws_route_table_association" "public-mobikart-SN-association" {
  subnet_id      = aws_subnet.public-mobikart-SN.id
  route_table_id = aws_route_table.public-mobikart-RT.id
}