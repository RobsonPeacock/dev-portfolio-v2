terraform {
  backend "s3" {
    bucket         = "robson-dev-portfolio-tfstate-msfin"
    key            = "dev-portfolio/live/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dev-portfolio-tf-state-locking"
    encrypt        = true
  }
}