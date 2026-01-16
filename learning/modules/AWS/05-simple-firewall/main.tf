# ----------------------------
# Provider Block - AWS Configuration
# ----------------------------
provider "aws" {
  region  = "us-east-1" # Deployment region (N. Virginia)
  profile = "terraform" # AWS CLI profile used for authentication
}

# ----------------------------
# Virtual Private Cloud Definition (acts as a virtual network)
# ----------------------------
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16" #Ipv4 Address range
  enable_dns_support               = true          #DNS Support
  enable_dns_hostnames             = true          #DNS FQDN Support
  assign_generated_ipv6_cidr_block = true          #IPv6 Support
}

# ----------------------------
# Security Group Definition (acts as a virtual firewall)
# ----------------------------
resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"   # Name of the Security Group
  description = "Created by Terraform" # Optional description
  vpc_id      = aws_vpc.main.id        # Associated VPC ID

  tags = { #Tag Block for the rule
    Name = "allow_443-tcp"
  }
}

# ----------------------------
# Ingress Rule - Allow HTTPS (IPv4)
# ----------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block # Source IPv4 range allowed to connect
  from_port         = 443                     # Start of port range
  ip_protocol       = "tcp"                   # Protocol type (TCP)
  to_port           = 443                     # End of port range
}

# ----------------------------
# Ingress Rule - Allow HTTPS (IPv6)
# ----------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.main.ipv6_cidr_block # Source IPv6 range allowed to connect
  from_port         = 443                          # Start of port range
  ip_protocol       = "tcp"                        # Protocol type (TCP)
  to_port           = 443                          # End of port range
}

# ----------------------------
# Egress Rule - Allow All Traffic (IPv4)
# ----------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0" # Allow outbound traffic to any IPv4 destination
  ip_protocol       = "-1"        # -1 = all protocols and ports (TCP, UDP, ICMP, etc.)
}

# ----------------------------
# Egress Rule - Allow All Traffic (IPv6)
# ----------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0" # Allow outbound traffic to any IPv6 destination
  ip_protocol       = "-1"   # -1 = all protocols and ports (TCP, UDP, ICMP, etc.)
}