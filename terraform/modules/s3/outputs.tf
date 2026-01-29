output "bucket_id" {
  value = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.frontend.bucket}.s3.ap-northeast-2.amazonaws.com"
}