pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-test-app"
        CONTAINER_NAME = "react-test-container"
        HOST_PORT = "8081" 
    }

    // git branch: 'main', url: https://github.com/chokkadevops/react-app.git
    // choose specific branch - main or dev. pulls the code from exact branch as  initiated.
    // safer as compared to hardcoding the git repo link

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        // Docker image is created. 
        // Image_Name is appended with Build version number.

        stage('Docker Build (CI)') {
            steps {
                echo "Starting Docker build process..."
                // This triggers the internal 'npm run build' inside the multi-stage Dockerfile
                 sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                // Alternative bulletproof syntax:
                //sh "docker build -t " + env.IMAGE_NAME + ":" + env.BUILD_NUMBER + " ."
                
            }
        }

        // Docker 

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

    
}