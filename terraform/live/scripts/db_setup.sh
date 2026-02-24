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

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin jq -y

usermod -aG docker ubuntu

systemctl start docker

systemctl enable docker
systemctl enable containerd

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)

aws ssm put-parameter --name "/prod/backend/dev_portfolio_db_host" --value "$PRIVATE_IP" --overwrite --region ${aws_region}

aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${aws_region}.amazonaws.com

docker pull ${account_id}.dkr.ecr.${aws_region}.amazonaws.com/dev-portfolio-api:latest

docker system prune --all --force

mkdir -p /home/ubuntu/db_data

sudo chown 999:999 /home/ubuntu/db_data

eval $(aws ssm get-parameters-by-path \
    --path "/prod/backend" \
    --with-decryption \
    | jq -r '.Parameters[] | "export \(.Name | split("/") | last | ascii_upcase)=\(.Value | @sh)"')

cat <<EOF > /home/ubuntu/docker-compose.yml
  services:
    db:
      image: postgres:18
      environment:
        - POSTGRES_USER=$${DEV_PORTFOLIO_PG_USER}
        - POSTGRES_PASSWORD=$${DEV_PORTFOLIO_PG_PASSWORD}
        - APP_USER=$${DEV_PORTFOLIO_DB_USERNAME}
        - APP_USER_PASSWORD=$${DEV_PORTFOLIO_DB_PASSWORD}
        - POSTGRES_DB=$${DEV_PORTFOLIO_DB_NAME}
      ports:
        - "5432:5432"
EOF

cd /home/ubuntu

docker compose up -d db

echo "Waiting for database to be ready..."

until docker compose exec db pg_isready -h db -U postgres; do
  sleep 3
done

echo "DB Started"