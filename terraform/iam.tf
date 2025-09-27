data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "myapp" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:ap-south-1:${data.aws_caller_identity.current.account_id}:parameter/myapp/hello_msg"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:ap-south-1:${data.aws_caller_identity.current.account_id}:log-group:/eks/myapp-logs*:*"
    ]
  }
}

resource "aws_iam_policy" "myapp" {
  name        = "myapp-policy"
  description = "Policy for myapp pods to read SSM and write CloudWatch logs"
  policy      = data.aws_iam_policy_document.myapp.json
}
