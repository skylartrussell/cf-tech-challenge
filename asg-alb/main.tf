/* ASG */
#Create ASG
resource "aws_autoscaling_group" "main" {
    name = "httpd-servers"
    min_size = 2
    max_size = 6
    launch_configuration = aws_launch_configuration.main.name
    vpc_zone_identifier = var.subnet_ids
    target_group_arns = [aws_lb_target_group.main.arn]
}
#Create launch configuration
resource "aws_launch_configuration" "main" {
    name = "httpd-server"
    image_id = "ami-06640050dc3f556bb"
    instance_type = "t2.micro"
    user_data = "../user-data/aws-user-data.sh"
    security_groups = var.security_groups
    root_block_device {
        volume_size = 20
    }
}
/* ALB */
#Create ALB
resource "aws_lb" "main" {
    load_balancer_type = "application"
    subnets = var.subnet_ids
}
#Create ALB listener
resource "aws_lb_listener" "main" {
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.main.arn
    }
}
#Create target group
resource "aws_lb_target_group" "main" {
    port = 8080
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = var.vpc_id
}