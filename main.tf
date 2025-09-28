terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

##############################
# Variables
##############################

variable "app_name" {
  type    = string
  default = "myapp"
}

variable "sns_topic_name" {
  type    = string
  default = "alerts-topic"
}

variable "ec2_instance_id" {
  type    = string
  default = "i-xxxxxxxxxxxx"
}

variable "rds_instance_id" {
  type    = string
  default = "mydb-instance"
}

##############################
# SNS Topic
##############################

resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name
}

##############################
# CloudWatch Log Group & Lambda
##############################

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/${var.app_name}/application"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.app_name}-pii-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_lambda_function" "strip_pii" {
  filename         = "lambda/pii_strip.zip" # upload your zip here
  function_name    = "${var.app_name}-strip-pii"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = filebase64sha256("lambda/pii_strip.zip")
}

resource "aws_cloudwatch_log_subscription_filter" "pii_filter" {
  name            = "${var.app_name}-pii-filter"
  log_group_name  = aws_cloudwatch_log_group.app_logs.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.strip_pii.arn
}

##############################
# CloudWatch Dashboard
##############################

resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "${var.app_name}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type       = "metric",
        x          = 0,
        y          = 0,
        width      = 12,
        height     = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", var.ec2_instance_id ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type       = "metric",
        x          = 0,
        y          = 6,
        width      = 12,
        height     = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "ReplicaLag", "DBInstanceIdentifier", var.rds_instance_id ]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "RDS Replica Lag"
        }
      }
    ]
  })
}

##############################
# CloudWatch Alarms
##############################

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.app_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "rds_lag" {
  alarm_name          = "${var.app_name}-rds-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "http_errors" {
  alarm_name          = "${var.app_name}-http-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.alerts.arn]
}
