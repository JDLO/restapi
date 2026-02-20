pipeline {
	options {
        // Solo guarda los últimos 5 builds y borra los artefactos de los antiguos
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    agent any
    environment {
        AWS_ACCOUNT_ID = '595575695437'
        AWS_DEFAULT_REGION = 'us-east-1'
        IMAGE_REPO_NAME = 'mi-app-springboot'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    stages{
		stage('Checkout') {
            steps {
                checkout scm
            }
        }
		
        stage('Java Build & Test') {
            agent {
                docker { 
                    image 'maven:3.9-eclipse-temurin-17'
                    args '-v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=""'
                    reuseNode true
                }
            }
            steps {
                sh 'mvn clean package -Dmaven.repo.local=/var/maven/.m2'
            }
        }
        
        stage('Build & push Docker Image'){
            steps {
                script {					
	                withCredentials([[
	                    $class: 'AmazonWebServicesCredentialsBinding',
	                    credentialsId: 'aws-credentials-id',
	                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
	                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
	                ]]){
                        sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"


                        sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."


                        sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                        sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:latest"


                        sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                        sh "docker push ${REPOSITORY_URI}:latest"
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                echo 'Iniciando limpieza profunda para ahorrar espacio...' 
                
                sh "docker rmi ${IMAGE_REPO_NAME}:${IMAGE_TAG} || true"
                sh "docker rmi ${REPOSITORY_URI}:${IMAGE_TAG} || true"
                sh "docker rmi ${REPOSITORY_URI}:latest || true"
                
                sh 'docker image prune -f'
            }
        }
	}
}