# Provider Block - e.g. AWS, Azure, GCP 
provider "aws" {
  region  = "eu-central-1" # selected Region to deploy
  profile = "terraform"    # implemented the use of AWS profiles
}

# AWS EC2 Example
resource "aws_instance" "test_server" {   # Resource Block - instance type and unique name
  ami           = "ami-015f3aa67b494b27e" # Argument - free Tier - Amazon Linux 2023 kernel-6.1 AMI, available in selected Region
  instance_type = "t2.micro"              # Argument - change me

  tags = { #Tag Block for the instance
    Name        = "test-server"
    Environment = "dev"
    Owner       = "student"
  }
}
resource "aws_instance" "web_server" {    # Resource Block - instance type and unique name
  ami           = "ami-015f3aa67b494b27e" # Argument - free Tier - Amazon Linux 2023 kernel-6.1 AMI, available in selected Region
  instance_type = "t2.micro"              # Argument - change me 

  tags = { #Tag Block for the instance
    Name        = "web-server"
    Environment = "prod"
    Owner       = "customer"
  }
}