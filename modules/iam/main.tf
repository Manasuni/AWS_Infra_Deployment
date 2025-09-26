variable "environment" {
  type = string
}

variable "ssm_parameter_path" {
  type        = string
  description = "Path prefix for SSM parameters (e.g., /my-app/dev/)"
}

# -------------------------------
# Caller Identity
# -------------------------------
data "aws_caller_identity" "current" {}

# -------------------------------
# OIDC Assume Role Policy (GitHub Actions)
# -------------------------------
data "aws_iam_policy_document" "assume_ci" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:your-org/your-repo:ref:refs/heads/main"]
    }
  }
}

# -------------------------------
# Provisioner Role (Terraform CI/CD)
# -------------------------------
resource "aws_iam_role" "provisioner" {
  name               = "ci-terraform-provisioner-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_ci.json
}

data "aws_iam_policy_document" "provisioner" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:DescribeParameters"
    ]
    resources = ["arn:aws:ssm:*:*:parameter${var.ssm_parameter_path}*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "config:Put*",
      "config:Describe*",
      "config:Get*",
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "guardduty:CreateDetector",
      "guardduty:UpdateDetector",
      "guardduty:Get*",
      "guardduty:ListDetectors"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "provisioner_policy" {
  name   = "ci-provisioner-policy-${var.environment}"
  role   = aws_iam_role.provisioner.id
  policy = data.aws_iam_policy_document.provisioner.json
}

# -------------------------------
# Scan Runner Role (runtime / CI scans)
# -------------------------------
resource "aws_iam_role" "scan_runner" {
  name               = "ci-scan-runner-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_ci.json
}

data "aws_iam_policy_document" "scan_runner" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:*:parameter${var.ssm_parameter_path}*"]
  }
}

resource "aws_iam_role_policy" "scan_runner_policy" {
  name   = "ci-scan-runner-policy-${var.environment}"
  role   = aws_iam_role.scan_runner.id
  policy = data.aws_iam_policy_document.scan_runner.json
}

# -------------------------------
# Outputs
# -------------------------------
output "provisioner_role_arn" {
  value = aws_iam_role.provisioner.arn
}

output "scan_runner_role_arn" {
  value = aws_iam_role.scan_runner.arn
}
