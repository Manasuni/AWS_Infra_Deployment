# Infrastructure as Code (IaC) – AWS EKS, RDS, ElastiCache

This project provisions a complete AWS infrastructure for a cloud-native application using **Terraform**.  
It follows modular design principles with reusable modules under `modules/` and a root configuration that ties everything together.

---

## 📐 Architecture Overview

The infrastructure is designed to be **highly available, secure, and scalable**.

### Networking
- VPC spanning **two Availability Zones**
- Public and private subnets
- Internet Gateway + NAT Gateways
- Custom route tables

### Compute
- **Amazon EKS** cluster (Kubernetes)
- Two managed node groups
- Service mesh: **Istio**
- Package manager: **Helm**
- Auto-scaling with CPU + custom CloudWatch metrics

### Data Storage
- **Amazon RDS (PostgreSQL)**  
  - Multi-AZ failover  
  - Encrypted at rest with KMS  
- **Amazon ElastiCache (Redis)** cluster  
- **Amazon S3**  
  - Static assets bucket  
  - Terraform state bucket (with versioning + encryption)

### Security
- IAM roles & policies with **least privilege**  
- Security Groups & NACLs isolating each tier  
- KMS keys for RDS, S3, ElastiCache encryption

---

## 📂 Project Structure

├── modules/ # Reusable Terraform modules
│ ├── vpc/ # Networking (VPC, subnets, routes, IGW, NAT)
│ ├── eks/ # EKS cluster + node groups
│ ├── rds/ # PostgreSQL
│ ├── redis/ # ElastiCache Redis
│ ├── s3/ # S3 buckets (static + state)
│ ├── security/ # IAM roles, policies, KMS, SGs, NACLs
│ └── ...
│
├── main.tf # Root module composition
├── variables.tf # Input variables
├── outputs.tf # Outputs
├── provider.tf # AWS provider config
└── README.md # Project documentation
