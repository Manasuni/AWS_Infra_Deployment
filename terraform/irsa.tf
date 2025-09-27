# Get EKS cluster + OIDC info
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"] # standard for AWS OIDC
  url             = "https://oidc.eks.ap-south-1.amazonaws.com/id/6C8F735F515146506C0D4025E799C27B"
}

# IAM Role for ServiceAccount
resource "aws_iam_role" "myapp" {
  name = "myapp-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:default:myapp-sa"
          }
        }
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "myapp" {
  role       = aws_iam_role.myapp.name
  policy_arn = aws_iam_policy.myapp.arn
}
