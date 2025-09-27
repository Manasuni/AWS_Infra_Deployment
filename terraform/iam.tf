# IAM Policy for MyApp Pods
data "aws_iam_policy_document" "myapp" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/eks/myapp-logs*:*"]
  }
}

resource "aws_iam_policy" "myapp" {
  name        = "myapp-policy"
  description = "Policy for myapp pods to read SSM and write CloudWatch logs"
  policy      = data.aws_iam_policy_document.myapp.json
}
