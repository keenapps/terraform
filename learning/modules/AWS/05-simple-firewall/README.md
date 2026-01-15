# AWS VPC + Security Group (HTTPS) with Terraform (IPv4 + IPv6)

This Terraform example shows how to provision an **AWS VPC (dual-stack IPv4/IPv6)** and a **Security Group** that:
- allows **HTTPS (TCP/443)** *only within the VPC address ranges* (IPv4 + IPv6)
- allows **all outbound traffic** (IPv4 + IPv6)

---

## Overview

This configuration demonstrates how to:
- Create a **VPC** with an IPv4 CIDR (`10.0.0.0/16`) and an **AWS-generated IPv6 CIDR**.
- Enable **DNS support** and **DNS hostnames** in the VPC.
- Define a **Security Group** attached to the VPC.
- Add **separate ingress/egress rule resources** using `aws_vpc_security_group_*_rule`.

### Key Highlights
- VPC: **IPv4 + IPv6** enabled
- Ingress: **TCP/443** restricted to:
  - `10.0.0.0/16` (the VPC IPv4 CIDR)
  - the VPC-assigned IPv6 CIDR
- Egress: **all protocols/ports** allowed to:
  - `0.0.0.0/0` (IPv4)
  - `::/0` (IPv6)

> Note: This does **not** allow internet-to-instance HTTPS access. It allows HTTPS only from inside the VPC address space.

---

## Terraform Workflow

1. **Initialize the working directory**

2. **Review the planned infrastructure**

3. **Deploy the configuration**

4. **Verify deployment**

In the AWS Console (make sure you are in us-east-1):

- VPC exists with IPv4 CIDR 10.0.0.0/16 and an assigned IPv6 block
- Security Group terraform-firewall exists
- Inbound rules show TCP/443 restricted to the VPC CIDRs
- Outbound rules allow all traffic (IPv4 + IPv6)

5. **Clean up resources**

Destroys all resources created by this configuration to avoid ongoing costs.

9. **Proof of Concept**
The screenshots below confirm the successful deployment.

![Security Group deployed](./img/SecurityGroup.png)