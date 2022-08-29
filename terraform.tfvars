#Network
main_vpc_cidr = "10.1.0.0/16"
sub1          = "10.1.0.0/24"
sub2          = "10.1.1.0/24"
sub3          = "10.1.2.0/24"
sub4          = "10.1.3.0/24"

#AWS Settings
aws_region     = "us-east-1"

#Linux Virtual Machine
linux_instance_type               = "t2.micro"
linux_associate_public_ip_address = true
linux_root_volume_size            = 20
linux_root_volume_type            = "gp2"
