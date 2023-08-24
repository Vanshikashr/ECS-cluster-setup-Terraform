provider "aws" {
  region = "us-east-1"  # Change to your desired region
  profile = "default" 
}

resource "aws_lb_target_group" "test" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}




resource "aws_lb" "test" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = toset([var.security_group])
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = aws_lb_target_group.test.arn
    type             = "forward"
  }

}

resource "aws_lb_target_group_attachment" "test" {
  count             = 3
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.asg_instance_ids[count.index]
  port             = 80
}

