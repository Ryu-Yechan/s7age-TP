terraform {
  backend "s3" {
    bucket         = "stage-tfstate-backup"
    key            = "stage/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}