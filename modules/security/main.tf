resource "aws_guardduty_detector" "main" {
  enable = true

  /*lifecycle {
    prevent_destroy = true
  }*/
}
