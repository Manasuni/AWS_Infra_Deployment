# CloudWatch Log Group for MyApp
resource "aws_cloudwatch_log_group" "myapp" {
  name              = "/eks/myapp-logs"
  retention_in_days = 7

  tags = {
    Name = "myapp-logs"
    Environment = "non-prod"
  }
}
