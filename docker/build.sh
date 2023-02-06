# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl enable docker

# Build Project
sudo docker compose -f /docker/docker-compose.yml up -d --build
