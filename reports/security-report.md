# Gemini Security Report

✅ GuardDuty is enabled across the account  
✅ AWS Config rules applied:
  - Disallowed Security Group open to 0.0.0.0/0
  - Unencrypted S3 buckets
  - RDS instances without encryption  

✅ No hardcoded secrets detected in Terraform  
✅ Application secrets stored in AWS SSM Parameter Store (SecureString)  
