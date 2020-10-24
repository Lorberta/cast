#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=lorberta/cast:v1

# Step 2
# Run the Docker Hub container with kubernetes
kubectl create deployment --image $dockerpath cast --port=80

# Step 3:
# List kubernetes pods
kubectl get pods
kubectl get deployments

# Step 4:
# Forward the container port to a host
kubectl port-forward deployment/cast 8000:80
