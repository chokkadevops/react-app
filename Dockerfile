
# Developer : Chokkalingam
# Date : 09-07-2026
# Test project : React App
# Defining the Docker container to have its environment setup for hosting the React Application.


# Stage 1: Build the React Application

# Download the Node.js version 20 image from Docker Hub on Alpine Linux
# builder = compiled output can be referenced and pulled later into stages
 FROM node:20-alpine AS builder

 #Creates a directory called /app inside the container filesystem and sets it as the active working directory. 
 #Any subsequent commands will execute inside this folder.
 WORKDIR /app

 #copy from your local computer into the current directory
 COPY package*.json ./

 # Install Node package to download all external libraries listed in package.json
 # file creating node_modules folder in the container filesystem.
 RUN npm install

 #copies remaining local source code files from host machine into the container's work directory.
 COPY . .
 # FIX: Grant executable permission to all binaries in node_modules
 RUN chmod -R +x node_modules/.bin
 #Triggers the build script specified in package.json. 
 #This compiles, minifies, and bundles your raw React components into static HTML, CSS, and JS files, saving them in a new /app/build directory
 RUN npm run build

 # Stage 2: Production environment using Nginx
 FROM nginx:stable-alpine
 COPY --from=builder /app/build /usr/share/nginx/html
 EXPOSE 80
 CMD ["nginx", "-g", "daemon off;"]

