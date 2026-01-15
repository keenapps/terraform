# ----------------------------
# Random ID Generator (Multiple Instances)
# ----------------------------
# Creates 2 random IDs (count = 2). Each instance can be referenced by index:
# random_id.random[0], random_id.random[1]
resource "random_id" "random" {
  byte_length = 8 # Length of the random value in bytes (8 bytes = 64-bit)
  count       = 2 # Number of random IDs to generate
}

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
  count         = 2
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = { # Tags help with identification and cost tracking
    Name = "EC2 from Terraform${random_id.random[count.index].dec}"
  }
}

# ----------------------------
# Elastic IP - just allocated
# ----------------------------
resource "aws_eip" "eip" { # Resource ID instead of direct assignment
  count  = 2
  domain = "vpc" # Allocate the EIP for usage in a VPC

  tags = { # Tags help with identification and cost tracking
    Name = "EIP from Terraform${random_id.random[count.index].dec}"
  }
}

# ----------------------------
# Elastic IP Association
# ----------------------------
resource "aws_eip_association" "eip_to_instance" {
  count         = 2
  allocation_id = aws_eip.eip[count.index].id              # EIP Allocation ID
  instance_id   = aws_instance.test_server[count.index].id # Target-Instance
}

# ----------------------------
# Output Allocated IPs
# ----------------------------
output "elastic_ips" {
  value = [for e in aws_eip.eip : e.public_ip] # Collect all public IPs
}

output "instance_ids" {
  value = [for i in aws_instance.test_server : i.id] # Collect all instance IDs
}