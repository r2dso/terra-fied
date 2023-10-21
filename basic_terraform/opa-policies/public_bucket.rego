package main

import input as tfplan

public_ssh_cidr(resource) {
    ingress := resource.ingress[_]
    cidr_block := ingress.cidr_blocks[_]
    port := ingress.to_port
    port == 22
}

deny[msg] {
    resource := tfplan.resource_changes[_]
    public_ssh_cidr(resource.change.after)
    msg = sprintf("Public CIDR block has been configured at resource %v", [resource.address])
}