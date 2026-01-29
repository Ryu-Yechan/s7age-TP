variable "env_name" {
  description = "Workspace name"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
}

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
}

variable "custom_domains" {
  description = "Custom domain names for CloudFront"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN for custom domain"
  type        = string
  default     = ""
}

variable "web_acl_id" {
  description = "waf"
  type        = string
}
