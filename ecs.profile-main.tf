
/*
 | --
 | -- This ECS task role is effectively a bucket for the policies and is specifying
 | -- that ECS tasks are the vessel that will gain (or be denied) the access defined
 | -- in the file-based JSON policy statement.
 | -- 
*/
resource aws_iam_role ecs-tasks {
    name = "task-role-${ var.in_ecosystem }-${ var.in_timestamp }"
    assume_role_policy = file( "${path.module}/ecs.profile-role.json" )
}


/*
 | --
 | -- Wrap up the policy statements inside the specified JSON file to form a policy
 | -- declaration that will be attached by hte policy attachment resource.
 | --
*/
resource aws_iam_policy ecs-policies {
    name = "task-policy-${ var.in_ecosystem }-${ var.in_timestamp }"
    policy = var.in_policy_stmts
}


/*
 | --
 | -- Attach together and tie up the IAM role and the IAM policies in a
 | -- neat little bundle for use by the ECS cluster.
 | --
*/
resource aws_iam_role_policy_attachment ecs-task-attachment {
    role = aws_iam_role.ecs-tasks.name
    policy_arn = aws_iam_policy.ecs-policies.arn
}

