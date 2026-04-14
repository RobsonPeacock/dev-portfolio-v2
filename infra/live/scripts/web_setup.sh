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

cat <<EOF > /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

systemctl start docker

systemctl enable docker
systemctl enable containerd

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_base_url}

echo "IMAGE_TAG=$(aws ecr describe-images \
  --repository-name dev-portfolio-api \
  --query 'sort_by(imageDetails, &imagePushedAt)[-1].imageTags[0]' \
  --output text)" > /home/ubuntu/.env

source /home/ubuntu/.env

docker pull ${ecr_base_url}/dev-portfolio-api:$${IMAGE_TAG}

docker system prune --all --force

eval $(aws ssm get-parameters-by-path \
    --path "/prod/backend" \
    --with-decryption \
    | jq -r '.Parameters[] | "export \(.Name | split("/") | last | ascii_upcase)=\(.Value | @sh)"')

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /home/ubuntu/docker-compose.yml
  services:
    web:
      image: ${ecr_base_url}/dev-portfolio-api:\$IMAGE_TAG
      ports:
        - $${PRIVATE_IP}:80:3000
      working_dir: /app
      environment:
        - APP_USER=$${DEV_PORTFOLIO_DB_USERNAME}
        - APP_USER_PASSWORD=$${DEV_PORTFOLIO_DB_PASSWORD}
        - DATABASE_URL=postgresql://$${DEV_PORTFOLIO_DB_USERNAME}:$${DEV_PORTFOLIO_DB_PASSWORD}@$${DEV_PORTFOLIO_DB_HOST}:5432/$${DEV_PORTFOLIO_DB_NAME}
        - RAILS_MASTER_KEY=$${DEV_PORTFOLIO_RAILS_MASTER_KEY}
EOF

cd /home/ubuntu

until nc -z $${DEV_PORTFOLIO_DB_HOST} 5432; do
  echo "Waiting for Postgres at $${DEV_PORTFOLIO_DB_HOST}:5432..."
  sleep 2
done

echo "Postgres is up!"

docker compose run --rm web bin/rails db:migrate

docker compose up -d web