
/*
 | -- This ec2 role is effectively a bucket for the policies and is specifying
 | -- that an ec2 instance (as opposed to a RDS database or EKS cluster) is the
 | -- vessel that will gain access as defined by the policies passed in through
 | -- the in_policy_stmts variable.
 | --
*/
resource aws_iam_role ec2_instance_role {
    name               = "ec2-role-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    assume_role_policy = file( "${path.module}/ec2.profile-role.json" )
}


/*
 | -- This resource unites the incoming (json formatted) policy statements with
 | -- the IAM ec2 role.
 | --
 | -- The incoming policy statements should be sent in JSON format and should be treated
 | -- as sensitive and not put under version control.
 | --
 | -- If a hacker knows exactly what policies a piece of infrastructure has, they
 | -- get a head start by knowing which infrastructure to focus on compromising.
 | --
*/
resource aws_iam_role_policy ec2_instance_policy {
    name   = "ec2-policy-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    role   = aws_iam_role.ec2_instance_role.id
    policy = var.in_policy_stmts
}


/*
 | -- This is the instance profile whose ID is given to whichever aws_instance
 | -- resource that needs to gain access as per the above policy statements.
 | --
 | -- The output variable [out_instance_profile_id] uses this resource.
 | --    ${ aws_iam_instance_profile.ec2_instance_profile.id }
 | --
*/
resource aws_iam_instance_profile ec2_instance_profile {
    name = "ec2-profile-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    role = aws_iam_role.ec2_instance_role.name
}
