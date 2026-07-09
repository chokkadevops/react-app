# Stage 1: Build the React Application
 FROM node:20-alpine AS builder
 WORKDIR /app
 COPY package*.json ./
 RUN npm install

 COPY . .
 # FIX: Grant executable permission to all binaries in node_modules
 RUN chmod -R +x node_modules/.bin
 RUN npm run build

 # Stage 2: Production environment using Nginx
 FROM nginx:stable-alpine
 COPY --from=builder /app/build /usr/share/nginx/html
 EXPOSE 80
 CMD ["nginx", "-g", "daemon off;"]

