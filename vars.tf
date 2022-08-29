variable "main_vpc_cidr" {}
variable "sub1" {}
variable "sub2" {}
variable "sub3" {}
variable "sub4" {}
variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}
variable "aws_region" {
  type        = string
  description = "AWS region"
}
