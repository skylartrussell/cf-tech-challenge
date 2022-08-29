# Create EC2 Instance in sub2
resource "aws_instance" "linux-server" {
  ami                         = data.aws_ami.rhel_8_5.id
  instance_type               = var.linux_instance_type
  subnet_id                   = aws_subnet.sub2.id
  vpc_security_group_ids      = [aws_security_group.aws-linux-sg.id]
  associate_public_ip_address = var.linux_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = file("user-data/aws-user-data.sh")

  # root disk
  root_block_device {
    volume_size           = var.linux_root_volume_size
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "linux-vm"
  }
}
# Create Elastic IP for the EC2 instance
resource "aws_eip" "linux-eip" {
  vpc = true
  tags = {
    Name = "linux-eip"
  }
} # Associate Elastic IP to Linux Server
resource "aws_eip_association" "linux-eip-association" {
  instance_id   = aws_instance.linux-server.id
  allocation_id = aws_eip.linux-eip.id
}

module "asg-alb" {
  source     = ".//asg-alb"
  subnet_ids = [aws_subnet.sub3.id, aws_subnet.sub4.id]
  vpc_id     = aws_vpc.Main.id
  security_groups = [aws_security_group.aws-linux-sg.id]
}