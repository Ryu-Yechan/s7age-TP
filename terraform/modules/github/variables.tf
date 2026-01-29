variable "repository_name" { type = string }
variable "site_name" { type = string }
variable "environment_name" { type = string }  # "Dev"

variable "domain_name" { type        = string }

variable "github_owner" { type = string }
variable "allowed_branches" { type = list(string) }
variable "allowed_environments" { type = list(string) }

variable "iam_name_prefix" { type = string }

variable "s3_bucket" { type = string }  # bucket name
variable "cloudfront_distribution_id" { type = string } 

variable "existing_oidc_provider_arn" {
  type    = string
  default = null
}
variable "dev_domain" {
  type        = string
}
