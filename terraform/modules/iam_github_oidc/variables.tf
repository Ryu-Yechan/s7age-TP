variable "name" { type = string }

variable "github_owner" { type = string }
variable "github_repo" { type = string }

variable "allowed_branches" {
  type    = list(string)
  default = ["dev"]
}

variable "s3_bucket_name" {
  description = "Bucket name (not ARN)"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "Optional. If null, allow invalidation on *"
  type        = string
  default     = null
}

variable "existing_oidc_provider_arn" {
  description = "If OIDC provider already exists, pass its ARN to avoid 409"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "allowed_environments" {
  description = "Allowed GitHub Environments for OIDC sub claim (e.g., DEV, PROD)"
  type        = list(string)
  default     = []
}
