# Provider Block - e.g. AWS, Azure, GCP 
provider "aws" {
  alias = "frankfurt"   # alias to use as variable in code
  region = "eu-central-1" # selected Region to deploy
  profile = "terraform" # implemented the use of AWS profiles
}
#Provider Block - different Region
provider "aws" {
  alias = "stockholm"  # alias to use as variable in code
  region = "eu-north-1" # selected Region to deploy
  profile = "terraform" # implemented the use of AWS profiles
}

# Random ID Generator to implement unique name suffixes
resource "random_pet" "suffix1" {
    length = 2
}

# Random ID Generator to implement unique name suffixes
resource "random_pet" "suffix2" {
    length = 2
}

# AWS EC2 Example
resource "aws_instance" "web_server_frankfurt" { # Resource Block - instance type and unique name
  provider      = aws.frankfurt #Using the alias from the provider block to specify the region
  ami           = "ami-015f3aa67b494b27e" # Argument - free Tier - Amazon Linux 2023 kernel-6.1 AMI, available in selected Region
  instance_type = "t2.micro" # Argument

  tags = {  #Tag Block for the instance
    Name        = "web-server${random_pet.suffix1.id}" #Implementig the Random Generator for unique names"
    Environment = "prod"
    Owner       = "customer"
  }
}
resource "aws_instance" "web_server_stockholm" { # Resource Block - instance type and unique name
  provider      = aws.stockholm #Using the alias from the provider block to specify the region
  ami           = "ami-0b46816ffa1234887" # Argument - free Tier - Amazon Linux 2023 kernel-6.1 AMI, available in selected Region
  instance_type = "t3.micro" # Argument - available type

  tags = {  #Tag Block for the instance
    Name        = "web-server${random_pet.suffix2.id}" #Implementig the Random Generator for unique names"
    Environment = "prod"
    Owner       = "customer"
  }
}