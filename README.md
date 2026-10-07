# 🔒 Secure Private Web Infrastructure on AWS

A production-grade AWS architecture that deploys an isolated, dockerized web application and self-hosted database within private subnets. The application is safely exposed to the public internet using **Amazon CloudFront** and **CloudFront VPC Origins**, keeping compute instances completely invisible to direct public access.

## 🏗️ Architecture Overview

```
                          [ Internet User ]
                                 │
                               HTTPS
                                 ▼
                     [ Amazon CloudFront ]
                                 │
                     [ CloudFront VPC Origin ]
                                 │
                          (Private Subnet)
                                 │
                   ┌─────────────┴─────────────┐
                   ▼                           ▼
       [ Private Web EC2 ]            [ Private DB EC2 ]
      (Dockerized App Host)           (Self-Hosted Database)

```

### Key Highlights

* **🛡️ Zero Public IP Compute:** EC2 compute instances reside strictly inside private subnets without public IPv4 addresses, minimizing exposure to external scans and attacks.

* **🌐 Direct Private Ingress:** Traffic proxies directly from CloudFront into private VPC subnets using AWS CloudFront VPC Origins, eliminating the need for public load balancers or internet gateways.

* **🔄 Zero-Downtime Instance Rotations:** Infrastructure configured with Terraform lifecycle rules (`create_before_destroy` and `replace_triggered_by`) to seamlessly swap EC2 instances without triggering CloudFront state-lock conflicts (`CannotUpdateEntityWhileInUse`).

* **🔑 Bastionless Administration:** Fully SSH-free management, debugging, and container updates managed securely via AWS Systems Manager (SSM) and isolated VPC Endpoints.

## ⚙️ Terraform Lifecycle & Deployment Strategy

Rotating private EC2 instances behind a CloudFront VPC Origin requires careful dependency management because AWS locks the VPC Origin resource while attached to an active distribution.

To allow non-blocking `terraform apply` executions during EC2 replacements:

```
resource "aws_cloudfront_vpc_origin" "ec2" {
  vpc_origin_endpoint_config {
    name                   = "private-ec2-origin"
    arn                    = aws_instance.web.arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [aws_instance.web.id]
  }
}

```

## 🚀 Deployment Options

Choose the path that fits your current objective:

* **⚡ Quick Start (Local Evaluation):** Run the application locally with Docker Compose. **No AWS credentials or cloud setup required.**

* **☁️ Full Production Deployment:** Provision the AWS VPC, CloudFront, EC2 instances, and SSM secrets via Terraform.

### ⚡ 1. Local Quick Start (Run Locally in 2 Minutes)

Use this option if you simply want to run and test the application on your local machine without spinning up AWS resources.

#### Prerequisites

* [Docker](https://www.docker.com/) & Docker Compose

#### Steps

1. **Clone the repository:**

   ```
   git clone https://github.com/your-username/aws-private-vpc-origin.git
   cd aws-private-vpc-origin
   
   ```

2. **Set up local environment variables:**

   ```
   cp .env.example .env
   
   ```

3. **Configure your `.env` file:**

   ```
   ALLOWED_ORIGIN=http://localhost:3000
   DEV_PORTFOLIO_DB_HOST=localhost
   DEV_PORTFOLIO_DB_NAME=dev_portfolio_development
   DEV_PORTFOLIO_DB_USERNAME=postgres
   DEV_PORTFOLIO_PG_USER=postgres
   DEV_PORTFOLIO_DB_PASSWORD=postgres
   DEV_PORTFOLIO_PG_PASSWORD=postgres
   DEV_PORTFOLIO_RAILS_MASTER_KEY=your_local_master_key_here
   
   ```

4. **Launch the local container environment:**

   ```
   docker-compose up -d
   
   ```

> 💡 **Finished!** If you only need to run the application locally, you are all set. Skip the section below unless you want to provision the production infrastructure on AWS.

### ☁️ 2. Full AWS Infrastructure Deployment

Follow these steps if you are deploying the architecture to your AWS account.

#### Prerequisites

* [Terraform](https://www.terraform.io/) (>= 1.5.0)

* [AWS CLI](https://aws.amazon.com/cli/) configured with administrative deployment credentials

#### Step 1: Provision Infrastructure via Terraform

1. **Initialize Terraform:**

   ```
   terraform init
   
   ```

2. **Deploy the stack:**

   ```
   terraform plan
   terraform apply
   
   ```

#### Step 2: Configure Environment Variables & Secrets via SSM

Production secrets and runtime variables are fetched by EC2 instances from **AWS Systems Manager (SSM) Parameter Store** under your application prefix (e.g., `/app/prod/`).

##### Required Parameters

| Parameter Name | Type | Description | 
| ----- | ----- | ----- | 
| `allowed_origin` | `String` | Allowed CORS domain (e.g., `https://yourdomain.com`) | 
| `dev_portfolio_db_host` | `String` | Database host or IP address | 
| `dev_portfolio_db_name` | `String` | Production database name | 
| `dev_portfolio_db_username` | `String` | Database username | 
| `dev_portfolio_pg_user` | `String` | PostgreSQL superuser account | 
| `dev_portfolio_db_password` | `SecureString` | Database user password | 
| `dev_portfolio_pg_password` | `SecureString` | PostgreSQL superuser password | 
| `dev_portfolio_rails_master_key` | `SecureString` | Master key for decrypting Rails credentials | 

##### AWS CLI Commands

```
# Example for standard String parameter:
aws ssm put-parameter \
  --name "/app/prod/allowed_origin" \
  --value "https://yourdomain.com" \
  --type "String" \
  --overwrite

# Example for sensitive SecureString parameter:
aws ssm put-parameter \
  --name "/app/prod/dev_portfolio_db_password" \
  --value "YourSuperSecretPassword123!" \
  --type "SecureString" \
  --overwrite

```

##### AWS Console Method

1. Navigate to **Systems Manager** → **Parameter Store** → **Create parameter**.

2. Set the parameter name (e.g., `/app/prod/allowed_origin`), choose `String` or `SecureString`, enter the value, and save.

3. Repeat for all required parameters.

#### Step 3: Application Startup & Database Setup

Upon EC2 creation, the `user_data` boot script automatically executes:

1. **SSM Injection:** Pulls production parameters securely into the instance environment.

2. **Database Migration:** Runs `bin/rails db:prepare` automatically.

3. **Container Launch:** Starts the containerized Rails server on port `80`/`443`.

## 🛠️ Local CI/CD Workflow Testing (`act`)

To test GitHub Actions workflows locally without pushing commits or triggering actual remote runs, you can use [act](https://github.com/nektos/act):

```
# Store temporary credentials/secrets in a local .secrets file (ensure it is in .gitignore)
echo "AWS_ROLE_ARN=arn:aws:iam::123456789012:role/GitHubActionsDeployRole" > .secrets
echo "AWS_REGION=eu-west-2" >> .secrets

# Run the GitHub Actions workflow locally
act push -s .secrets

```

## 🧪 Security Verification

To verify that the compute layer is entirely private and non-routable from the public internet:

1. **Direct IP Check:** Attempt direct HTTP access to the EC2 instance's private IP from outside the VPC (will fail).

2. **CloudFront Ingress:** Access the application via the CloudFront domain URL—traffic successfully proxies through the private VPC Origin to the containerized app.