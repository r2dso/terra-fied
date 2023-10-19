# Welcome to Terra-fied!

This repository hosts a collection of Terraform modules designed to demonstrate various security considerations and potential pitfalls when managing infrastructure as code (IAC) using Terraform. Through hands-on examples, users can explore common misconfigurations and learn best practices to ensure a secure and robust Terraform setup.
## Modules Overview

    Network Module: Sets up basic networking resources including VPCs, subnets, and security groups.
    Keys Module: Manages SSH key pairs for secure access to EC2 instances.
    Instances Module: Deploys EC2 instances with varying configurations to illustrate different security postures.
    Weak IAM Roles Module: Creates intentionally weak IAM roles to demonstrate the importance of least privilege principles.

## Features

    Dynamic Resource Creation: Utilize the count parameter to easily toggle the creation of resources.
    Real-world Scenarios: Explore real-world scenarios like a reverse shell setup through the remote-exec provisioner, and discover how to mitigate such risks.
    Interactive Learning: Modify and apply configurations to see first-hand the impact of different security settings.

### Usage

Clone this repository and navigate to the basic_terraform directory. Ensure you have Terraform installed and AWS credentials configured. Follow the instructions in each module's README for detailed setup and usage information.


# Terraform Commands Rundown

This document provides a short rundown of running commands with the appropriate variables for the Terraform configurations in this repository.

## Planning

1. **Initial Plan**:
   Run a simple `terraform plan` to see what changes Terraform intends to make without any additional variable overrides.
   ```bash
   terraform plan
   ```

2. **Plan with Remote Exec Enabled**:
   Run a `terraform plan` with the `remoteexec_enabled` variable set to `true` to see how the plan changes.
   ```bash
   terraform plan -var="remoteexec_enabled=true"
   ```

3. **Plan with Both Remote Exec and Weak Instance Enabled**:
   Run a `terraform plan` with both the `remoteexec_enabled` and `weakinstance_enabled` variables set to `true`.
   ```bash
   terraform plan -var="remoteexec_enabled=true" -var="weakinstance_enabled=true"
   ```

## Applying

Apply the configuration using `terraform apply`. For example, to apply the configuration with both `remoteexec_enabled` and `weakinstance_enabled` set to `true`:
```bash
terraform apply -var="remoteexec_enabled=true" -var="weakinstance_enabled=true"
```

## Destroying Resources

Once you are done with the resources, you can destroy them using `terraform destroy`. If you applied the configuration with certain variable overrides, you'll need to provide the same overrides when destroying:
```bash
terraform destroy -var="remoteexec_enabled=true" -var="weakinstance_enabled=true"
```