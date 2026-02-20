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
                    args '-u 0:0 --entrypoint="" -e MAVEN_CONFIG=""'
                }
            }
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean package -Dmaven.repo.local=/var/maven/.m2'
            }
        }
        
        stage('Build & push Docker Image'){
            steps {
                script {
					sh 'ls -la target/'
					sh 'rm -f target/*.original'
					
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
        post {
	        always {
	            script {
	                echo 'Iniciando limpieza profunda para ahorrar espacio...'
	                
	                // 1. Borrar el Workspace de Jenkins (archivos, target, logs)
	                cleanWs() 
	                
	                // 2. Borrar la imagen Docker recién creada del registro local
	                // Para que no se acumulen versiones viejas en el disco de la EC2
	                sh "docker rmi ${IMAGE_REPO_NAME}:${IMAGE_TAG} || true"
	                sh "docker rmi ${REPOSITORY_URI}:${IMAGE_TAG} || true"
	                sh "docker rmi ${REPOSITORY_URI}:latest || true"
	                
	                // 3. Limpieza de imágenes "huérfanas" (dangling images)
	                // Borra capas intermedias que quedaron sin uso
	                sh 'docker image prune -f'
	            }
	        }
    	}
    }
}