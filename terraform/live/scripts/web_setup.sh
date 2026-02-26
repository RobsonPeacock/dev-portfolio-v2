#!/bin/bash

sudo apt-get update -y
sudo apt-get install apt-transport-https unzip ca-certificates curl gnupg lsb-release software-properties-common -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

usermod -aG docker ubuntu

systemctl start docker

systemctl enable docker
systemctl enable containerd

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${aws_region}.amazonaws.com

docker pull ${account_id}.dkr.ecr.${aws_region}.amazonaws.com/dev-portfolio-api:latest

docker system prune --all --force

eval $(aws ssm get-parameters-by-path \
    --path "/prod/backend" \
    --with-decryption \
    | jq -r '.Parameters[] | "export \(.Name | split("/") | last | ascii_upcase)=\(.Value | @sh)"')

cat <<EOF > /home/ubuntu/docker-compose.yml
  services:
    web:
      image: ruby:${ruby_version}-slim
      ports:
        - 127.0.0.1:3000:3000
      working_dir: /app
      volumes:
      - ./:/app
      environment:
        - APP_USER=$${DEV_PORTFOLIO_DB_USERNAME}
        - APP_USER_PASSWORD=$${DEV_PORTFOLIO_DB_PASSWORD}
        - DATABASE_URL=postgres://$${DEV_PORTFOLIO_DB_USERNAME}:@db:5432/$${DEV_PORTFOLIO_DB_NAME}
      tty: true
      stdin_open: true
EOF

cd /home/ubuntu

docker compose up -d web