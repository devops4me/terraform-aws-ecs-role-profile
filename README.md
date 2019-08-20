
#### Given an input string of IAM policy statements that give or revoke access privileges this terraform module delivers a role profile that can be fed to an ECS cluster thus making that ECS cluster inherit the aforementioned permissions.


# ecs task role profile | iam policy statements

**We need our ECS cluster tasks to inherit access to AWS resources like S3 buckets, ECS repositories, CloudFront and AWS ElasticSearch.

We pass in a chunk of AWS (json formatted) policy statements in the variable **`in_policy_stmts`** and reap the **`out_ecs_tasks_role_arn`** that can be fed into the **`task_role_arn`** property of the **`aws_ecs_task_definition`** resource.

## Usage

``` hcl
module ec2-instance-profile
{
    source = "github.com/devops4me/terraform-aws-ecs-role-profile"

    in_policy_stmts    = data.template_file.ecs_policy_stmts.rendered

    in_ecosystem_name  = var.in_ecosystem_name
    in_tag_timestamp   = var.in_timestamp
}
```

After declaring this Terraform module you use its output within the **`aws_instance`** resource block.

``` hcl
resource aws_instance ec2-instance
{

    iam_instance_profile = "${ module.ec2-instance-profile.out_ec2_instance_profile }"

}
```

## Example Policy Statements | Access to S3 and CloudFront

You want your **ec2 instance** to access **S3 and CloudFront**. Set **`in_policy_stmts`** like this.

**`in_policy_stmts = "${ data.template_file.iam_policy_stmts.rendered }"`**

```
data template_file iam_policy_stmts
{
    template = "${ file( "${path.module}/ec2.profile-policy-stmts.json" ) }"
}
```

Now create this JSON file in the path called **ec2.profile-policy-stmts.json**.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Sid": "AllowAllCloudFrontPermissions",
            "Action": ["cloudfront:*"],
            "Resource": "*"
	}
    ]
}
```
