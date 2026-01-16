# ----------------------------
# Provider Block - AWS Configuration
# ----------------------------
provider "aws" {
  region  = "us-east-1" # AWS region where resources will be created (N. Virginia)
  profile = "terraform" # AWS CLI profile used for authentication/credentials
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "test_server" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = { # Tags help with identification and cost tracking
    Name = "EC2 from Terraform"
  }
}

# ----------------------------
# Elastic IP - just allocated
# ----------------------------
resource "aws_eip" "eip1" { # Resource ID instead of direct assignment
  domain = "vpc"            # Allocate the EIP for usage in a VPC

  tags = { # Tags help with identification and cost tracking
    Name = "EIP from Terraform"
  }
}

# ----------------------------
# Elastic IP Association
# ----------------------------
resource "aws_eip_association" "eip1_to_instance" {
  allocation_id = aws_eip.eip1.id             # EIP Allocation ID
  instance_id   = aws_instance.test_server.id # Target-Instance
}

# ----------------------------
# Print the allocated IP Address to CLI
# ----------------------------
output "elastic_ip" {
  value = aws_eip.eip1.public_ip
}