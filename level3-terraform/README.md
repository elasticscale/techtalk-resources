# Level 3 – Terraform ECS Deployment

This repo provisions AWS infrastructure to run your Dockerized PHP app using:

- ECS Fargate
- Application Load Balancer (optional)
- ECR (Docker registry)
- VPC with public subnets
- CloudWatch logs

## 🚀 Usage

### 1. Build & push your Docker image manually

```bash
aws ecr get-login-password | docker login --username AWS --password-stdin <ecr_url>
docker build -t <ecr_url>:latest .
docker push <ecr_url>:latest
