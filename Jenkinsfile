pipeline {
    agent any

   
    environment {
         IMAGE_NAME = "react-test-app"
     }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build (CI)') {
            steps {
                // We pass the build number so Docker registers the specific tag locally
                sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage ('Docker Deploy (IaC CD)') {
            steps {
                echo "Deploying ReactApp using Docker Compose..."
                // Using double quotes allows Jenkins to swap ${IMAGE_NAME} and ${env.BUILD_NUMBER} before sending to bash
                // Commented by Chokka. Testing multiple services.
                // sh "IMAGE_NAME=${IMAGE_NAME} TAG=${env.BUILD_NUMBER} HOST_PORT=${HOST_PORT} /usr/bin/docker-compose up -d --force-recreate"
                sh "IMAGE_NAME=${IMAGE_NAME} TAG=${env.BUILD_NUMBER}  /usr/bin/docker-compose up -d --force-recreate"
            }
        }

      
    } 
}