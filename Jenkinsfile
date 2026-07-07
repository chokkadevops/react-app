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
                echo "Starting Docker build process..."
                // This triggers the internal 'npm run build' inside the multi-stage Dockerfile
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Docker Deploy (CD)') {
            steps {
                echo "Deploying built image to runtime container..."
                script {
                    // Gracefully handle removing existing container if it exists
                    def status = sh(script: "docker ps -a -q -f name=${CONTAINER_NAME}", returnStdout: true).trim()
                    if (status) {
                        echo "Existing container found. Stopping and removing..."
                        sh "docker rm -f ${CONTAINER_NAME}"
                    }
                }
                // Run the newly built container mapping your local port to Nginx port 80
                sh "docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:80 ${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline executed successfully. App live at http://localhost:${HOST_PORT}"
        }
        failure {
            echo "Pipeline failed. Check stage logs for details."
        }
    }
}