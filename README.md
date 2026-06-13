# AWS DevOps CI/CD Pipeline

A full-stack application deployed on AWS using Jenkins, Docker, ECS, and Terraform with a fully automated CI/CD pipeline.

## Overview

This repository contains a React frontend and an Express backend. The frontend connects to the backend API which returns a unique ID proving successful communication between services.

## Live URLs

- **Frontend:** http://3.91.189.145
- **Jenkins Server:** http://54.161.197.90:8080
- **Backend Load Balancer:** http://tc1-alb-940602008.us-east-1.elb.amazonaws.com:8080

## Architecture

```
Developer pushes code to GitHub
        ↓
Jenkins detects push
        ↓
Builds Docker images (frontend + backend)
        ↓
Pushes images to Amazon ECR
        ↓
Deploys to Amazon ECS
        ↓
Application live on internet!
```

## Technologies Used

- **Jenkins** - CI/CD automation server
- **Docker** - Container platform
- **AWS ECS** - Container orchestration (Fargate)
- **AWS ECR** - Container image registry
- **AWS ALB** - Application Load Balancer
- **Terraform** - Infrastructure as Code
- **React** - Frontend application
- **Node.js/Express** - Backend API

## Project Structure

```
aws-devops-pipeline/
├── frontend/              # React frontend application
│   ├── Dockerfile
│   ├── src/
│   │   ├── App.js
│   │   └── config.js
│   └── package.json
├── backend/               # Express backend API
│   ├── Dockerfile
│   ├── index.js
│   ├── config.js
│   └── package.json
├── terraform/             # Infrastructure as Code
│   ├── main.tf
│   └── outputs.tf
├── Jenkinsfile            # CI/CD pipeline definition
└── README.md
```

## Tools Required

- AWS CLI
- Docker
- Terraform v1.0+
- Node.js v16+
- Jenkins

## Deployment Steps

### Step 1 - Clone Repository

```bash
git clone https://github.com/ABDON72/aws-devops-pipeline
cd aws-devops-pipeline
```

### Step 2 - Create ECR Repositories

```bash
aws ecr create-repository --repository-name frontend --region us-east-1
aws ecr create-repository --repository-name backend --region us-east-1
```

### Step 3 - Deploy Infrastructure with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This creates:
- ECS Cluster
- ECS Task Definitions
- ECS Services
- Application Load Balancer
- Security Groups
- IAM Roles

### Step 4 - Build and Push Docker Images

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com

# Build and push backend
cd backend
docker build -t backend .
docker tag backend:latest YOUR-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/backend:latest
docker push YOUR-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/backend:latest

# Build and push frontend
cd ../frontend
docker build -t frontend .
docker tag frontend:latest YOUR-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
docker push YOUR-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
```

### Step 5 - Setup Jenkins Server

1. Launch EC2 instance (t2.medium, Ubuntu 22.04)
2. Install Java 21:
```bash
sudo apt update
sudo apt install openjdk-21-jdk -y
```
3. Download and run Jenkins:
```bash
sudo wget -O /opt/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
sudo java -jar /opt/jenkins.war --httpPort=8080 &
```
4. Install Docker:
```bash
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
```
5. Install AWS CLI:
```bash
sudo apt install awscli -y
aws configure
```
6. Access Jenkins at http://YOUR-JENKINS-IP:8080
7. Install plugins: Docker Pipeline, Amazon ECR, Pipeline AWS Steps
8. Add AWS credentials in Jenkins
9. Create Pipeline job pointing to this repository

### Step 6 - Run Pipeline

1. Click Build Now in Jenkins
2. Pipeline automatically:
   - Pulls code from GitHub
   - Builds Docker images
   - Pushes to ECR
   - Deploys to ECS

## Run Application Locally

### Backend
```bash
cd backend
npm ci
npm start
```
Backend runs on http://localhost:8080

### Frontend
```bash
cd frontend
npm ci
npm start
```
Frontend runs on http://localhost:3000

If frontend successfully connects to backend, a unique GUID will be displayed.

## CI/CD Pipeline Stages

| Stage | Description |
|-------|-------------|
| Checkout | Pull latest code from GitHub |
| Login to ECR | Authenticate Docker with AWS ECR |
| Build Images | Build frontend and backend Docker images |
| Push to ECR | Push images to Amazon ECR |
| Deploy to ECS | Force new deployment on ECS services |

## Infrastructure Components

| Component | Value |
|-----------|-------|
| ECS Cluster | tc1-cluster |
| Frontend Service | frontend-service |
| Backend Service | backend-service |
| Load Balancer | tc1-alb |
| AWS Region | us-east-1 |

## Jenkins Server Infrastructure

- Instance type: t2.medium
- OS: Ubuntu 22.04 LTS
- Java: OpenJDK 21
- Jenkins: Latest stable WAR
- Port: 8080
- Security Group: SSH (22), HTTP (80), Jenkins (8080)

## Author

**Abdon Njunwa**
- GitHub: https://github.com/ABDON72


