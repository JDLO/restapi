pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID = '595575695437'
        AWS_DEFAULT_REGION = 'us-east-1'
        IMAGE_REPO_NAME = 'mi-app-springboot'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION.amazonaws.com}/${IMAGE_REPO_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Tests') {
            steps {
                // Ejecuta los tests de Spring Boot
                sh './mvnw clean test'
            }
        }

        stage('Build Artifact') {
            steps {
                // Crea el JAR omitiendo tests ya realizados
                sh './mvnw package -DskipTests'
            }
        }
        /*
        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Login a Amazon ECR
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    
                    // Construcción de la imagen
                    dockerImage = docker.build("${IMAGE_REPO_NAME}:${IMAGE_TAG}")
                    
                    // Taggeo y Push
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                // Actualiza el servicio en ECS con la nueva imagen
                sh "aws ecs update-service --cluster mi-cluster --service mi-servicio --force-new-deployment --region ${AWS_DEFAULT_REGION}"
            }
        }*/
    }
}