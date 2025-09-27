terraform {
  backend "s3" {
    bucket         = "manasha-demo-s3"
    key            = "terraform/state/myapp.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks-part4"
    encrypt        = true
  }
}
