
output "ecs_instance_role_name" {
    value = aws_iam_instance_profile.ecs_instance_profile.name    # output instance_profile name
}

output "ecs_task_execution_role_name" {
    value = aws_iam_role.ecs_task_execution_role.arn             # output task execution role arn
}

output "ecs_service_role_name" {
    value = aws_iam_instance_profile.ecs_service_role_profile.name        # output service role name
}