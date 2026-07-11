pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-test-app"
        CONTAINER_NAME = "react-test-container"
        HOST_PORT = "8081" 
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

        stage('Docker Deploy (IaC CD)') {
            steps {
                echo "Deploying ReactApp using Docker Compose..."
                
                // We explicitly pass the BUILD_NUMBER into the environment of the shell execution
                // and use the absolute path to guarantee execution stability
                sh "IMAGE_NAME=${IMAGE_NAME} TAG=${env.BUILD_NUMBER} HOST_PORT=${HOST_PORT} /usr/bin/docker-compose up -d"
            }
        }
    } 
}