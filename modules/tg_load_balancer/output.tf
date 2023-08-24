output "aws_lb" {
    value = aws_lb.test.dns_name
  
}

output "target_group_arn" {
  value = aws_lb_target_group.test.arn
}
