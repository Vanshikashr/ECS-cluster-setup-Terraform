provider "aws" {
  region = "us-east-1"  # Change to your desired region
}


module "vpc" {
  source = "./modules/vpc"
  
}

module "security_group" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./modules/iam_roles"
}

module "ecs_cluster" {
  source = "./modules/cluster_td"
  execution_role_arn = module.iam_roles.ecs_task_execution_role_name
  target_group_arn = module.tg_load_balancer.target_group_arn
}


module "asg" {
  source = "./modules/asg"
  sg_id = module.security_group.sg_id
  cluster_name = module.ecs_cluster.cluster_name
  ecs_instance_profile_name = module.iam_roles.ecs_instance_role_name
  subnet_ids = module.vpc.public_subnet_ids
}


module "tg_load_balancer" {
  source = "./modules/tg_load_balancer"
  vpc_id = module.vpc.vpc_id
  security_group = module.security_group.sg_id
  subnet_ids = module.vpc.public_subnet_ids
  asg_instance_ids = module.asg.asg_instance_ids
}
