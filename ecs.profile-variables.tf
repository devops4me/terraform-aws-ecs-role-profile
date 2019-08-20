
### ########################################## ###
### ec2 instance profile [mandatory] variables ###
### ########################################## ###

### ############### ###
### in_policy_stmts ###
### ############### ###

variable in_policy_stmts {

    description = "The Policy statements defining the AWS resource access the ec2 instances will enjoy."
}


### ################# ###
### in_ecosystem_name ###
### ################# ###

variable in_ecosystem {

    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
}


### ################ ###
### in_tag_timestamp ###
### ################ ###

variable in_timestamp {

    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}


