pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-react-app"
        CONTAINER_NAME = "react-app-container"
        PORT = "8080" // The port you want to access the app on outside the container
    }

    stages {
        stage('Checkout') {
            steps {
                // This checks out code from the SCM configured in the Jenkins job
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}..."
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Deploy Container') {
            steps {
                echo "Deploying container..."
                script {
                    // Check if a container with the same name is already running and stop/remove it
                    def containerExists = sh(script: "docker ps -a -q -f name=${CONTAINER_NAME}", returnStdout: true).trim()
                    if (containerExists) {
                        echo "Stopping and removing existing container..."
                        sh "docker rm -f ${CONTAINER_NAME}"
                    }
                }
                // Run the new container mapping host port to Nginx port 80
                sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:80 ${IMAGE_NAME}:latest"
                echo "Application is live at http://localhost:${PORT}"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs above."
        }
    }
}