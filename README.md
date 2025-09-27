repo/
├─ app/                # Your application code + Dockerfile + dependencies
│   ├─ requirements.txt # Python dependencies
│   ├─ app.py           # Application code
│   └─ Dockerfile       # Used to build Docker image
│
├─ terraform/          # All infrastructure as code
│   ├─ eks-logging.tf   # VPC, Subnets, EKS cluster with logging
│   ├─ ecr.tf           # ECR repository
│   ├─ iam.tf           # IAM policy for pods
│   ├─ irsa.tf          # IAM Role for ServiceAccount
│   ├─ cloudwatch.tf    # CloudWatch log group
│   └─ backend.tf       # S3 + DynamoDB backend for Terraform state
│
├─ helm-chart/         # Helm chart to deploy the app on EKS
│   ├─ Chart.yaml
│   ├─ templates/
│   │   ├─ deployment.yaml
│   │   ├─ service.yaml
│   │   └─ serviceaccount.yaml
│   └─ values.yaml     # Image, tag, ServiceAccount + IRSA, rolling update strategy
│
├─ .github/workflows/
│   └─ ci-cd.yml       # GitHub Actions CI/CD workflow
│
├─ .gitignore
└─ README.md


How everything works together
Step 1: Terraform (infra setup)

terraform/ contains all your infrastructure code.

Running terraform init && terraform apply does:

Creates VPC, subnets, route tables, IGW.

Creates EKS cluster + managed node group.

Creates IAM policy + IRSA role so pods can access SSM and CloudWatch.

Creates ECR repository for Docker images.

Creates CloudWatch log group /eks/myapp-logs.

This is your “foundation” — everything else depends on it.

Step 2: App folder (dependencies + Docker)

app/ contains your Python/Node.js code and requirements.txt.

The Dockerfile in app/ installs dependencies from requirements.txt.

When building a Docker image:

docker build -t myapp:latest app/


The image contains your app + all dependencies.

This image will later be pushed to ECR.

Step 3: Helm chart (deployment on EKS)

helm-chart/ contains Kubernetes manifests templated with Helm.

Helm uses the image in ECR to create pods on EKS.

It also configures:

ServiceAccount → linked to IRSA role (so pods can read SSM + write logs).

Rolling update strategy → zero downtime deploys.

Pod annotations → map IAM role for permissions.

Step 4: GitHub Actions workflow

.github/workflows/ci-cd.yml automates everything:

Job 1: Lint + Test + Terraform Validate

Runs Python linter (flake8) and unit tests (pytest).

Runs Terraform fmt + validate to check infra code.

Job 2: Build + Push Docker + Deploy

Builds Docker image from app/.

Tags and pushes image to ECR.

Runs terraform apply to ensure infra is up-to-date.

Configures kubectl to talk to your EKS cluster.

Deploys your app with Helm → rolling update.

With the workflow, every PR/test ensures app + infra are consistent.

Step 5: Logs

CloudWatch logs capture:

Infra logs → EKS control plane, node group, pod events.

Application logs → /eks/myapp-logs.

IAM + IRSA ensures pods have permission to write logs and read SSM parameters.

✅ Summary Flow
Local dev / GitHub Actions
          │
          ▼
   Build app + install dependencies (app/)
          │
          ▼
   Docker image created
          │
          ▼
   Push to ECR
          │
          ▼
   Helm deploys image to EKS (helm-chart/)
          │
          ▼
   Pods start on cluster (terraform infra)
          │
          ▼
   Pods read config from SSM + write logs to CloudWatch


Local dev / GitHub Actions
          │
          ▼
   Run lint + pytest on app/tests/testmain.py
          │
          ▼
   Only if tests pass → Docker image is built and pushed

So testmain.py is used purely for validation of your app logic.

It does not get deployed; only the main app code (app.py) goes into the Docker image.