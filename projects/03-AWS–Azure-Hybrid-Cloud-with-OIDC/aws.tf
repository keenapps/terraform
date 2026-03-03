resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "cf23df2207d99a74fbe169e3eba035e633b65d94",
  ]
  tags = {
    Name = "github-oidc"
  }
}

resource "aws_iam_role" "github_oidc" {
  name = "github-terraform-aws-hybrid"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::134071079482:oidc-provider/token.actions.githubusercontent.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:repository_owner" = "keenapps"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:keenapps/terraform:ref:refs/heads/main"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "networking" {
  name = "terraform-hybrid-net"
  role = aws_iam_role.github_oidc.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*Vpc*", "ec2:*Subnet*", "ec2:*Gateway*", "ec2:*Connection*"
        ]
        Resource = "*"
      }
    ]
  })
}
