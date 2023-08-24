provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "my_cluster" {
  name = "demo-cluster"
}


resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "demo-td"
  network_mode            = "bridge"  # Default network mode for EC2 launch type
  requires_compatibilities = ["EC2"]
  execution_role_arn      = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "drupal",
      image = "drupal:latest",
      cpu = 256,
      memory = 256,
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
        },
      ],
    }
    # Add more containers as needed
  ])
}



resource "aws_ecs_service" "my_ecs_service" {
  name            = "drupal-service"
  cluster         = aws_ecs_cluster.my_cluster.name
  task_definition = aws_ecs_task_definition.my_task_definition.family

  launch_type     = "EC2"
  desired_count   = 1  # Number of instances you want in the service

  

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "drupal"
    container_port   = 80
  }
}


