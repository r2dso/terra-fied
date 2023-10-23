package main

import input as tfplan

# Define a function to check the encryption of an EC2 instance's root volume
check_encryption(resource) {
    root_device := resource.values.root_block_device[_]
    root_device.encrypted == true
}

# Define a rule to identify EC2 instances that do not have encrypted root volumes
deny[msg] {
    resource := tfplan.planned_values.root_module.resources[_]
    resource.type == "aws_instance"
    not check_encryption(resource)
    msg = sprintf("EC2 instance %v does not have an encrypted root volume", [resource.address])
}
