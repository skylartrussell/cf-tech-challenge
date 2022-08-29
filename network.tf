/* VPC */
#Create VPC
resource "aws_vpc" "Main" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
}
/* Subnets */
#Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
#Create Public Subnets
resource "aws_subnet" "sub1" { #
  vpc_id            = aws_vpc.Main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.sub1
}
resource "aws_subnet" "sub2" { #
  vpc_id            = aws_vpc.Main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.sub2
}
#Create Private Subnets
resource "aws_subnet" "sub3" {
  vpc_id            = aws_vpc.Main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.sub3
}
resource "aws_subnet" "sub4" {
  vpc_id            = aws_vpc.Main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.sub4
}
/* Connections */
#Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
}
#Create route table for public subnets
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
#Create route table for private subnets
resource "aws_route_table" "PrivateRT1" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw1.id
  }
}
resource "aws_route_table" "PrivateRT2" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw2.id
  }
}
#Create route table association with public subnets
resource "aws_route_table_association" "PublicRTassociation1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.PublicRT.id
}
resource "aws_route_table_association" "PublicRTassociation2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.PublicRT.id
}
#Create route table association with private subnets
resource "aws_route_table_association" "PrivateRTassociation1" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.PrivateRT1.id
}
resource "aws_route_table_association" "PrivateRTassociation2" {
  subnet_id      = aws_subnet.sub4.id
  route_table_id = aws_route_table.PrivateRT2.id
}
#Elastic IPs for NatGW
resource "aws_eip" "natGW1" {
  vpc = true
}
resource "aws_eip" "natGW2" {
  vpc = true
}
#Create NAT Gateways
resource "aws_nat_gateway" "NATgw1" {
  allocation_id = aws_eip.natGW1.id
  subnet_id     = aws_subnet.sub1.id
}
resource "aws_nat_gateway" "NATgw2" {
  allocation_id = aws_eip.natGW2.id
  subnet_id     = aws_subnet.sub2.id
}
/* Security Groups */
# Define the security group for the Linux server
resource "aws_security_group" "aws-linux-sg" {
  name        = "linux-sg"
  description = "Allow incoming traffic to the Linux EC2 Instance"
  vpc_id      = aws_vpc.Main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
