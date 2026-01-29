resource "aws_s3_bucket" "frontend" {
  bucket = "${var.env_name}s7age-frontend-s3"
  force_destroy = terraform.workspace != "prod" #prod는 s3 삭제안되게
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  versioning_configuration {
    status = "Disabled" # 버전 관리 헐거면 -> Enabled
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
