
        #     
        #      ___ _   _ ____ _____  _    _   _  ____ _____ 
        #     |_ _| \ | / ___|_   _|/ \  | \ | |/ ___| ____|
        #      | ||  \| \___ \ | | / _ \ |  \| | |   |  _|  
        #      | || |\  |___) || |/ ___ \| |\  | |___| |___ 
        #     |___|_| \_|____/ |_/_/   \_\_| \_|\____|_____|
        #                                                   
        #     

provider "aws" {
  region = "us-east-1"  # Change to your desired region
  profile = "default" 
}
  


resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



resource "aws_iam_policy" "custom_ecs_policy" {
  name        = "CustomECSInstancePolicy"
  description = "Custom policy for ECS instances"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:TagResource",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ecs:CreateAction": [
                        "CreateCluster",
                        "RegisterContainerInstance"
                    ]
                }
            }
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "attach_custom_ecs_policy" {
  policy_arn = aws_iam_policy.custom_ecs_policy.arn
  role       = aws_iam_role.ecs_instance_role.name
}



resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRoleProfile"
  role = aws_iam_role.ecs_instance_role.name
}




        #     
        #      _____      _      ____    _  __  _____  __  __  _____    ____ 
        #     |_   _|    / \    / ___|  | |/ / | ____| \ \/ / | ____|  / ___|
        #       | |     / _ \   \___ \  | ' /  |  _|    \  /  |  _|   | |    
        #       | |    / ___ \   ___) | | . \  | |___   /  \  | |___  | |___ 
        #       |_|   /_/   \_\ |____/  |_|\_\ |_____| /_/\_\ |_____|  \____|
        #                                                                    

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "custom_ecs_task_execution_policy" {
  name        = "CustomECSTaskExecutionPolicy"
  description = "Custom policy for ECS task execution role"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy_attachment" {
  name       = "ecs-task-execution-policy-attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = aws_iam_policy.custom_ecs_task_execution_policy.arn
}



resource "aws_iam_instance_profile" "ecs_task_execution_role_profile" {
  name = "ecsTaskExecutionRoleProfile"
  role = aws_iam_role.ecs_task_execution_role.name
}
  


        # ____    _____   ____   __     __  ___    ____   _____ 
        #/ ___|  | ____| |  _ \  \ \   / / |_ _|  / ___| | ____|
        #\___ \  |  _|   | |_) |  \ \ / /   | |  | |     |  _|  
        # ___) | | |___  |  _ <    \ V /    | |  | |___  | |___ 
        #|____/  |_____| |_| \_\    \_/    |___|  \____| |_____|
        #                                                       

resource "aws_iam_role" "ecs_service_role" {
  name = "ecsServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "custom_ecs_service_policy" {
  name        = "CustomECSServicePolicy"
  description = "Custom policy for ECS service role"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_policy_attachment" "ecs_service_policy_attachment" {
  name       = "ecs-service-policy-attachment"
  roles      = [aws_iam_role.ecs_service_role.name]
  policy_arn = aws_iam_policy.custom_ecs_service_policy.arn
}


resource "aws_iam_instance_profile" "ecs_service_role_profile" {
  name = "ecsServiceRoleProfile"
  role = aws_iam_role.ecs_service_role.name
}
