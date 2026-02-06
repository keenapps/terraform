# Terraform Multi-Cloud Infrastructure

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=azure&logoColor=white)](https://azure.microsoft.com/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=black)](https://aws.amazon.com/)

This repository contains **Infrastructure as Code (IaC) examples** built with Terraform for **AWS, Azure**, and more. Learning modules, reusable components, and **portfolio demos** for DevOps job applications.

---

## Overview

Modular setups demonstrate provider authentication, networking, compute, and CI/CD. Learning modules build sequentially (see READMEs), production modules are generalized and reusable.

>Repository Structure Note
>
>/modules/... contains individual reusable provider or service modules.
>
>/learning/modules/... Each provider (e.g., AWS, Azure, GitHub, etc.) has its own sub-README with setup and authentication details.
>
>/project/... Complete demos with deployment guides
>
>Some module folders include documentation-only READMEs (architecture notes, explanations).
>
>The actual Terraform logic resides in .tf files (main.tf, variables.tf, outputs.tf, providers.tf, etc.).
>
>Learning Project Disclaimer
>This repository is designed for educational purposes. Some examples use simplified access permissions or mock configurations.
>Do not copy these directly to production environments without proper review of IAM policies, networking rules, and state management.

## Common Use Cases include:

- Setting up foundational networking and compute infrastructure
- Testing provider authentication and configuration methods
- Managing state, variables, and backends
- Demonstrating CI/CD workflows
- Comparing multiple cloud providers
- Portfolio projects for DevOps interviews

---

## Design Principles

- Learning: Sequential builds with explanations
- Reusable: Modules with variables/outputs
- Portfolio: Projects combining everything
- Security: No secrets unless in learning modules, use Managed Identity
- Best Practices: Official Terraform guidelines

---

## Technologies & Tools

- **Terraform** (Infrastructure as Code)
- **Cloud Providers** AWS, Azure (GCP planned)
- **GitHub / GitLab** for version control and automation
- **CLI Tools** (AWS CLI, Azure CLI, gcloud, etc.) for authentication and local testing

---

## Getting Started

### Prerequisites
- Terraform v1.10.x or later
- Access to at least one supported Cloud Provider (AWS, Azure, GCP, etc.)
- Basic CLI and Git knowledge
- Provider-specific CLI configured (e.g., aws configure, az login, or gcloud auth login)

---

### Basic Usage
1. Navigate to the desired deployment directory:

2. Initialize the Terraform working directory:
    -> terraform init

3. Preview and apply infrastructure changes:
    -> terraform plan
    -> terraform apply

4. Destroy resources that are no longer needed:
    -> terraform plan -destroy 
    -> terraform destory   

5. ⚠️ Always verify that all resources have been properly destroyed or terminated to avoid unnecessary costs.

---

### Provider Documentation


Terraform AWS Provider
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

Terraform Azure Provider
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

Terraform GitHub Provider
https://registry.terraform.io/providers/integrations/github/latest/docs

## Learning Project Disclaimer
This repository is designed for educational purposes. Some examples use simplified configurations. Review IAM policies, networking rules, and state management before production use.

## License

This repository is open-source and available under the MIT License
