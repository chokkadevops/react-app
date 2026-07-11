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

        stage ('Docker Deploy (IaC CD)')
        {

                steps {
                echo "Deploying ReactApp using Docker Compose..."
                // --build forces Docker to compile the Dockerfile changes
                // -d runs the container seamlessly in the background (detached mode)
                // Compose automatically stops and replaces the old container with no downtime
                // Added by Chokka
                // docker compose syntax varies based on version.
                sh "docker compose up -d --build"
            }

        }

        
    } 

 }   
   