terraform {
  backend "s3" {
    bucket         = "devops-assessment-tfstate-manasha"   # your S3 bucket
    key            = "terraform.tfstate"                  # path to store tfstate
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"                    # your DynamoDB table
    encrypt        = true                                 # enable encryption
  }
}
