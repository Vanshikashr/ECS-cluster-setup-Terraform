output "vpc_id" {
  value = aws_vpc.test_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

