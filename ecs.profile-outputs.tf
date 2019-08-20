
################ ########################################################## ########
################ Module [[[ ec2 instance profile ]]] Output Variables List. ########
################ ########################################################## ########

/*
 | --
 | -- Return the name of the ec2 instance profile that gives ec2 instances access to
 | -- create, read, update and/or delete the specified AWS resources.
 | --
 | -- Push into the iam_instance_profile field of the aws_instance resource.
 | --
*/
output out_instance_profile_id {
    description = "The name of the role profile that gives ec2 instances access to S3 buckets."
    value       = aws_iam_instance_profile.ec2_instance_profile.id
}
