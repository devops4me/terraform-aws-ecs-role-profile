
#### Given an input string of IAM policy statements (usually rendered from json formatted policy statements) this terraform module returns an ec2 instance profile that can be attached to an aws_instance thus giving it a role containing all the necessary permissions.


# ec2 instance role profile | iam policy statements

**We want our ec2 instances to inherit access to AWS resources like S3 buckets, ECS repositories, CloudFront and AWS ElasticSearch. We use roles to avoid explicitly passing IAM credentials into ec2 instances.**

Pass in chunk of AWS (json formatted) policy statements in the variable **`in_policy_stmts`** and reap the **`out_instance_profile_id`** that can be fed into the **`iam_instance_profile`** property of the **`aws_instance`** resource.

## Usage

``` hcl
module ec2-instance-profile
{
    source = "github.com/devops4me/terraform-aws-ec2-instance-profile"

    in_policy_stmts    = "${ data.template_file.iam_policy_stmts.rendered }"

    in_ecosystem_name  = "${local.ecosystem_id}"
    in_tag_timestamp   = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description = "${ module.resource-tags.out_tag_description }"
}
module resource-tags
{
    source = "github.com/devops4me/terraform-aws-resource-tags"
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

Create the ec2 instance and then login to check that it does indeed have access to S3 and CloudFront distributions.


```yaml
#cloud-config

ssh_authorized_keys:
  - "ssh-rsa xxxxx-abcde public key"

package_update: true

packages:
 - python3-pip
 - groff


runcmd:
  - [ sh, -c, "sudo pip3 install --upgrade awscli && pip3 --version && aws --version" ]
  - [ sh, -c, "aws s3 ls > /home/ubuntu/s3-acess-verification.txt" ]
```
