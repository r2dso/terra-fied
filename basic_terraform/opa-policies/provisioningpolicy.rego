package main

import input as tfconfig

# Rule to find local-exec provisioner commands
find_local_exec_commands[msg] {
    # Iterate over the resources
    resource := tfconfig.configuration.root_module.resources[_]
    provisioner := resource.provisioners[_]
    print(provisioner.type)
    expression := provisioner.expressions[_]
    command := expression.constant_value
    # command := expression.command
    # # Check if the provisioner block exists
    # Check if it's a local-exec provisioner
    provisioner.type == "local-exec"
    command == "echo"
    msg = sprintf("Found local-exec provisioner in resource %s", [resource.address])
}

# Entry point rule
deny[msg] {
    msg = find_local_exec_commands[_]
}
