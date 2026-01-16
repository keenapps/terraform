# ----------------------------
# Provider Block - AWS Configuration
# ----------------------------
provider "aws" {
  region  = "us-east-1" # AWS region where resources will be created (N. Virginia)
  profile = "terraform" # AWS CLI profile used for authentication/credentials
}

# ----------------------------
# Elastic IP Definition
# ----------------------------
resource "aws_eip" "eip1" {
  instance = aws_instance.test_server.id # EC2 instance to associate this Elastic IP with
  domain   = "vpc"                       # Allocate the EIP for usage in a VPC
}

# ----------------------------
# Elastic Compute Instance Definition
# ----------------------------
resource "aws_instance" "test_server" {
  ami           = "ami-068c0051b15cdb816" # AMI ID for us-east-1 (must exist in this region)
  instance_type = "t2.micro"              # Free-tier eligible instance typ

  tags = { # Tags help with identification and cost tracking
    Name = "EIP from Terraform"
  }
}