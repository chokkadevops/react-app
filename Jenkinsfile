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

        
        // Docker building an Image. Build number is fetched Jenkins pipeline.
        // -t verbose is for tag. tag the name identifier for the build image.
        // . is for current directory. It is mandatory syntax for this shell script.

        stage('Docker Build (CI)') {
            steps {
                
                // This triggers the internal 'npm run build' inside the multi-stage Dockerfile
                // verbose -t = tag the image with Image name and build number.
                 sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                
            }
        }

        /* // Docker run the build image. 
        

        stage('Docker Deploy (CD)') {
            steps {
                echo "Deploying built image to runtime container..."
                script {
                    // Gracefully handle removing existing container if it exists
                    // docker ps process status = list all active containers.
                    // docker ps -a = list all available containers. Both active and inactive containers.
                    // docker ps -a -q = quiet mode. Suppress output and only display container Id.
                    // docker ps -a -a -f = filter by ? name, filter by name from the list of container names. To fetch only container id.
                    def status = sh(script: "docker ps -a -q -f name=${CONTAINER_NAME}", returnStdout: true).trim()
                    if (status) {
                        echo "Existing container found. Stopping and removing..."
                        // docker rm = to permanently remove or delete a container
                        // docker rm -f = forcefully remove a container. Regardless of running or stoppped.
                        sh "docker rm -f ${CONTAINER_NAME}"
                    }
                }
                // Run the newly built container mapping your local port to Nginx port 80
                // docker run = docker create or start in a single syntax
                // -d = detached mode. Run the container in background.
                // without -d, NGINX web server will  lock up the jenkins terminal indefinitely.
                // --name = container name.
                // -p = publish
                // HOST_PORT = Defined in the environment. Port 80 is standard for the container port.
                sh "docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:80 ${IMAGE_NAME}:${env.BUILD_NUMBER}"
            
            }
        }
    } */

    
    stage('Docker Deploy (Test Environment)') {
    steps {
        script {
            def prodName = "${CONTAINER_NAME}"
            def tempName = "${CONTAINER_NAME}_temp"
            
            // 1. Check if the production container is currently running
            def isRunning = sh(script: "docker ps -q -f name=^${prodName}\$", returnStdout: true).trim()
            
            if (isRunning) {
                echo "Executing Native Docker-Managed Port Swap..."
                
                // STEP A: Pass '0' as the host port. Docker will pick a perfectly legal, permitted port automatically.
                sh "docker run -d --name ${tempName} -p 0:80 ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                
                // Give it a moment to stabilize
                sh "sleep 2"
                
                // OPTIONAL: If you want to see what port Docker picked in your logs:
                def assignedPort = sh(script: "docker port ${tempName} 80 | cut -d':' -f2", returnStdout: true).trim()
                echo "Docker successfully bound the temporary container to allowed port: ${assignedPort}"
                
                // STEP B: The Lightning Swap
                sh "docker rm -f ${prodName}"
                sh "docker rename ${tempName} ${prodName}"
                
                // Re-bind to your specific public production HOST_PORT
                sh "docker stop ${prodName}"
                sh "docker run -d --name ${prodName} -p ${HOST_PORT}:80 ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                
                // Clean up the temporary stopped container configuration
                sh "docker rm -f ${tempName} || true"
                
            } else {
                echo "Fresh deployment initialized on port ${HOST_PORT}."
                sh "docker run -d --name ${prodName} -p ${HOST_PORT}:80 ${IMAGE_NAME}:${env.BUILD_NUMBER}"
            }
        }
    }
}
    
    
    
    
    
    
    
    
    }