Cloud Native Application Deployment and Monitoring
This project demonstrates the deployment of a Node.js application using Google Kubernetes Engine (GKE) and the integration of monitoring and visibility tools such as Stackdriver and Prometheus. The application is containerized using Docker and deployed on a GKE cluster for scalability and reliability.

Table of Contents
Project Overview

Technologies Used

Deployment Steps

Monitoring Setup

Challenges Faced

Conclusion

Project Overview
This project involves the deployment of a Node.js application to Google Kubernetes Engine (GKE), using Google Cloud services such as Google Container Registry (GCR) for storing the Docker image and Google Cloud SDK for managing the GKE cluster. The application is also monitored using Stackdriver for logging and monitoring, with Prometheus integrated for advanced metrics collection.

Key Features
Node.js Application: A simple Express-based application serving a "Hello World" message.

Dockerization: The Node.js app is containerized using Docker to ensure portability across environments.

Kubernetes Deployment: Deployed on a GKE cluster for high availability and scalability.

Monitoring and Logging: Utilized Stackdriver for cloud-native monitoring and Prometheus for advanced metrics collection.

Technologies Used
Node.js: JavaScript runtime used to build the application.

Docker: Used for containerizing the Node.js application.

Google Kubernetes Engine (GKE): Used to manage the Kubernetes cluster for deployment.

Google Cloud SDK: CLI for interacting with GCP services.

Google Container Registry (GCR): Used for storing Docker images.

Stackdriver: GCP’s monitoring and logging service for collecting performance and error data.

Prometheus: An open-source monitoring system used for collecting metrics from the Kubernetes cluster.

Deployment Steps
1. Containerize the Node.js Application
A Dockerfile was created to define how the application is built into a Docker image:

dockerfile
Copy
# Use official Node.js image from Docker Hub
FROM node:16

# Create and set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Expose the app on port 3000
EXPOSE 3000

# Command to run the app
CMD ["node", "app.js"]
2. Push the Docker Image to Google Container Registry (GCR)
The Docker image was built locally and then pushed to GCR for storage:

bash
Copy
docker build -t my-node-app .
docker tag my-node-app gcr.io/<YOUR_PROJECT_ID>/my-node-app:latest
docker push gcr.io/<YOUR_PROJECT_ID>/my-node-app:latest
3. Deploy to Google Kubernetes Engine (GKE)
A GKE cluster was created, and the application was deployed using Kubernetes manifests (Deployment and Service):

Deployment.yaml:

yaml
Copy
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-node-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-node-app
  template:
    metadata:
      labels:
        app: my-node-app
    spec:
      containers:
      - name: my-node-app
        image: gcr.io/<YOUR_PROJECT_ID>/my-node-app:latest
        ports:
        - containerPort: 3000
Service.yaml:

yaml
Copy
apiVersion: v1
kind: Service
metadata:
  name: my-node-app-service
spec:
  selector:
    app: my-node-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer
These files were applied to the cluster using kubectl:

bash
Copy
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
Monitoring Setup
1. Stackdriver for Logging and Monitoring
Stackdriver was enabled for monitoring the health and performance of the Node.js application in GKE. Logs from the Kubernetes cluster and the application were sent to Stackdriver for real-time analysis.

Configured Stackdriver Logging to capture error logs and system logs from the Kubernetes environment.

Set up Stackdriver Monitoring to track key metrics such as CPU usage, memory utilization, and the number of incoming requests.

2. Prometheus for Advanced Metrics Collection
Prometheus was installed using Helm for advanced monitoring:

bash
Copy
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
Prometheus was configured to collect detailed metrics about the Kubernetes nodes, pods, and services.

Grafana was integrated to visualize these metrics in a dashboard for easier analysis.

Challenges Faced
1. Image Pull Issues
Problem: Kubernetes initially failed to pull the Docker image, resulting in the InvalidImageName and ImagePullBackOff errors.

Solution: The image was properly tagged and pushed to Google Container Registry (GCR). Docker authentication was configured using gcloud auth configure-docker.

2. Service LoadBalancer IP Pending
Problem: The LoadBalancer service in GKE took longer than expected to provision an external IP.

Solution: We waited for a few minutes for Google Cloud to provision the IP. Alternatively, a NodePort service was configured as a backup.

3. kubectl Authentication Issues
Problem: There were issues with kubectl authentication in Git Bash due to missing configuration files or environment variables.

Solution: The issue was resolved by running gcloud container clusters get-credentials to authenticate kubectl with the correct cluster.

Conclusion
This project demonstrated the end-to-end deployment of a cloud-native Node.js application using Google Kubernetes Engine (GKE). We used Google Cloud services such as Google Container Registry (GCR) for storing Docker images and Stackdriver for monitoring.

The Prometheus and Grafana tools were integrated to enhance monitoring with detailed metrics. Despite some initial challenges with image pulling and service provisioning, the issues were resolved, and the application was successfully deployed and exposed.

This setup demonstrates the powerful capabilities of Google Cloud for managing and scaling containerized applications while ensuring high availability and performance monitoring.