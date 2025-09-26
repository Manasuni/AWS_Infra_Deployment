resource "aws_guardduty_detector" "main" {
  enable = true
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}
