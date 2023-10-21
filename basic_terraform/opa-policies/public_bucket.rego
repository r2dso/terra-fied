package main

import input as tfplan

public_read_acl(resource) {
    resource.type == "aws_s3_bucket_acl"
    acl := resource.values.acl
    acl == "public-read"
}

lax_public_access_block(resource) {
    resource.type == "aws_s3_bucket_public_access_block"
    resource.values.block_public_acls == false
    resource.values.block_public_policy == false
    resource.values.ignore_public_acls == false
    resource.values.restrict_public_buckets == false
}

deny[msg] {
    resource := tfplan.resource_changes[_]
    print(resource)
    public_read_acl(resource.change.after)
    msg = sprintf("Public read access is granted to the S3 bucket by setting acl to public-read in resource %v", [resource.address])
}

deny[msg] {
    resource := tfplan.resource_changes[_]
    lax_public_access_block(resource.change.after)
    msg = sprintf("Lax public access block settings in the S3 bucket resource %v", [resource.address])
}
