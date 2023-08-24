provider "aws" {
  region = "us-east-1"  # Change to your desired region
}


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}



data "template_file" "ecs_script" {
  template = file("${path.module}/ecs_script.sh")  # Path to your script file

  vars = {
    cluster_name = var.cluster_name
  }
}



resource "aws_launch_template" "my_launch_template" {
  name  = "demo-launch-template"
  description   = "Demo launch template with ubuntu AMI"
  image_id      = data.aws_ami.ubuntu.id  # Ubuntu 20.04 LTS AMI
  instance_type = "t2.micro"
  key_name      = "virginia_key_pair"  # Replace with your key pair name
  vpc_security_group_ids = [var.sg_id]  # Replace with your security group ID

  iam_instance_profile {
    name = var.ecs_instance_profile_name  # Replace with the correct IAM instance profile name
  }


user_data = base64encode(data.template_file.ecs_script.rendered)

}


resource "aws_autoscaling_group" "my_asg" {
  name                 = "demo-asg"
  max_size             = 3
  min_size             = 3
  desired_capacity     = 3
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids  # List of subnet IDs

  # Other Auto Scaling Group settings can be added here
}

data "aws_instances" "my_asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.my_asg.name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

locals {
  instance_ids = [for instance in data.aws_instances.my_asg_instances.ids : instance]
}






# You can also add outputs to retrieve useful information, for example:


# output "autoscaling_group_name" {
#   value = aws_autoscaling_group.my_asg.name
# }
