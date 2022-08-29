variable "asg_min_size" {
    type = number
    description = "Minimum number of instances in ASG"
    default = 2
}
variable "asg_max_size" {
    type = number
    description = "Maximum number of instances in ASG"
    default = 6
}
variable "subnet_ids" {
    type = list(string)
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "vol-size" {
    type = number
    default = 20
}
variable "security_groups" {
    type = list(string)
}
variable "vpc_id" {
}