pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '795644302799.dkr.ecr.us-east-1.amazonaws.com'
        FRONTEND_IMAGE = 'frontend'
        BACKEND_IMAGE = 'backend'
        ECS_CLUSTER = 'tc1-cluster'
        FRONTEND_SERVICE = 'frontend-service'
        BACKEND_SERVICE = 'backend-service'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ABDON72/aws-devops-pipeline'
            }
        }
        
        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                    sh '''
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 795644302799.dkr.ecr.us-east-1.amazonaws.com
                    '''
                }
            }
        }
        
        stage('Build Images') {
            steps {
                sh '''
                    docker build -t frontend ./frontend
                    docker build -t backend ./backend
                '''
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh '''
                    docker tag frontend:latest 795644302799.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
                    docker tag backend:latest 795644302799.dkr.ecr.us-east-1.amazonaws.com/backend:latest
                    docker push 795644302799.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
                    docker push 795644302799.dkr.ecr.us-east-1.amazonaws.com/backend:latest
                '''
            }
        }
        
        stage('Deploy to ECS') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                    sh '''
                        aws ecs update-service --cluster tc1-cluster --service frontend-service --force-new-deployment --region us-east-1
                        aws ecs update-service --cluster tc1-cluster --service backend-service --force-new-deployment --region us-east-1
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Deployment successful! 🎉'
        }
        failure {
            echo 'Deployment failed! ❌'
        }
    }
}
