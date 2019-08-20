
################ ################################################### ########
################ Module [[[ ecs task role ]]] Output Variables List. ########
################ ################################################### ########

/*
 | --
 | -- Return the ARN of the role that gives ECS tasks access to create, read,
 | -- update and/or delete the specified AWS resources.
 | --
 | -- Place in the task_role_arn field of the aws_ecs_task_definition resource.
 | --
*/
output out_ecs_task_role_arn {
    description = "The ARN of the role that will give ECS tasks privileges to acess AWS resources."
    value       = aws_iam_role.ecs-tasks.arn
}
