#!/bin/bash

# Update package repositories and install necessary dependencies
sudo apt-get update -y && \
sudo apt-get -y install ca-certificates curl gnupg && \

# Add Docker GPG key and repository
sudo install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \

# Install Docker
sudo apt-get update -y && \
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \

# Change ownership of docker socket and enable Docker services
sudo chown ubuntu /var/run/docker.sock && \
sudo systemctl enable docker.service && \
sudo systemctl enable containerd.service && \

# Download and install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \

# Download and install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64  && \
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64 && \

# Add ubuntu user to the docker group
sudo usermod -aG docker ubuntu && \

# Switch to the ubuntu user and start Minikube
sudo su - ubuntu -c "minikube start --driver=docker"
