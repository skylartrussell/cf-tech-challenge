# RHEL 8.5 -- Stores variables for different versions of RHEL. This file supports the latest builds of 7 and 8 versions.
data "aws_ami" "rhel_8_5" {
  most_recent = true
  owners      = ["309956199498"] // Red Hat's Account ID  
  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
