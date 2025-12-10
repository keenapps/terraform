# Deploying Multiple EC2 Instances with Tags

This example demonstrates how to use **Terraform** to launch multiple **AWS EC2 instances** and apply **custom tags** to each resource.  
It walks through the full Terraform workflow for defining, provisioning, and managing compute resources on AWS.

---

## Overview

This configuration builds upon a single EC2 setup and extends it to demonstrate scalability and resource organization.

### Key Highlights
- Customized instance names for clear identification  
- Added a second EC2 instance to showcase scalable deployment  
- Applied descriptive tags to improve visibility and management across environments  

---

## Terraform Workflow

1. **Initialize the working directory**

   ```bash
   terraform init
   ```
Downloads the required provider plugins and prepares the backend.

2. **Review the planned infrastructure**

    ```bash
    terraform plan
    ```
Displays all actions Terraform will perform before applying changes.

3. **Deploy the configuration**

    ```bash
    terraform apply
    ```
Launches two EC2 instances with predefined tags and instance names.

4. **Verify deployment**

Open the AWS Management Console

Navigate to EC2 → Instances

Confirm that both instances are deployed and tagged correctly

5. **Clean up resources**

    ```bash
    terraform destroy
    ```
Destroys all resources created by this configuration to avoid ongoing costs.

Tagging Example
Each EC2 instance includes descriptive tags for easy filtering and cost allocation:

```hcl
  tags = {
    Name        = "test-server"
    Environment = "dev"
    Owner       = "student"
}

  tags = {
    Name        = "web-server"
    Environment = "prod"
    Owner       = "customer"
}
```
Using consistent tags is a best practice for managing cloud resources at scale.

6. **Proof of Concept**
The screenshot below confirms successful deployment of two tagged EC2 instances visible in the AWS EC2 Dashboard:
![2 instances deployed](./img/2xEC2-tagged.png)
![2 instances tagged](./img/2xEC2-tagged2.png)