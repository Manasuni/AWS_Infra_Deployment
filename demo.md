demo.md — Local CI/CD Testing
# Local CI/CD Demo Script

## 1️⃣ Set AWS Variables
```bash
export AWS_REGION=ap-south-1
export AWS_ACCOUNT_ID=<your_aws_account_id>
export EKS_CLUSTER_NAME=my-eks-cluster

2️⃣ Terraform - Init & Apply
cd terraform

# Initialize Terraform
terraform init

# Create/select workspace
terraform workspace new local || terraform workspace select local

# Validate config
terraform validate

# Plan & apply infra
terraform plan -out=tfplan
terraform apply tfplan


This will create:

VPC + subnets + IGW + route tables

EKS cluster + node group

IAM policy + IRSA role

CloudWatch log group

ECR repository

3️⃣ Build & Push Docker Image
cd ../app

# Build Docker image
docker build -t myapp:latest .

# Tag for ECR
docker tag myapp:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/myapp-repo:latest

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Push image
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/myapp-repo:latest

4️⃣ Configure kubectl
aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME
kubectl get nodes

5️⃣ Deploy Helm Chart
cd ../helm-chart

helm upgrade --install myapp ./ \
  --set image.repository=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/myapp-repo \
  --set image.tag=latest \
  --wait --timeout 10m

# Check pods
kubectl get pods
kubectl logs <pod-name>

6️⃣ Test App

Access your service (via LoadBalancer or port-forward)

kubectl port-forward svc/myapp 8080:80
curl http://localhost:8080

7️⃣ Cleanup (Optional)
cd ../terraform
terraform destroy -auto-approve


