#!/usr/bin/env bash
###################
useradd -m -g users d
passwd d

####################
set -e

echo "Updating packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing Docker and Docker Compose dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating apt & installing Docker & Compose plugin..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user to docker group (need to re-login)..."
sudo usermod -aG docker "$USER"

echo "Setup done. Docker installed."