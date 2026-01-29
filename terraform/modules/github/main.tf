locals {
  is_prod = terraform.workspace == "prod"
  custom_Dev_domains = local.is_prod ? "" : var.dev_domain
}


module "iam_github_oidc" {
  source = "../iam_github_oidc"

  name             = var.iam_name_prefix
  github_owner     = var.github_owner
  github_repo      = var.repository_name
  allowed_branches = var.allowed_branches
  allowed_environments = var.allowed_environments

  s3_bucket_name              = var.s3_bucket
  existing_oidc_provider_arn  = var.existing_oidc_provider_arn
}

resource "github_repository_environment" "this" {
  repository  = var.repository_name
  environment = var.environment_name
}

resource "github_actions_environment_secret" "aws_role_arn" {
  repository      = var.repository_name
  environment     = github_repository_environment.this.environment
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = module.iam_github_oidc.role_arn
}

resource "github_actions_environment_secret" "s3_bucket" {
  repository      = var.repository_name
  environment     = github_repository_environment.this.environment
  secret_name     = "S3_BUCKET"
  plaintext_value = var.s3_bucket
}

resource "github_actions_environment_secret" "cf_dist_id" {
  repository      = var.repository_name
  environment     = github_repository_environment.this.environment
  secret_name     = "CLOUDFRONT_DISTRIBUTION_ID"
  plaintext_value = var.cloudfront_distribution_id
}

resource "github_actions_environment_variable" "site_url" {
  repository      = var.repository_name
  environment     = github_repository_environment.this.environment
  variable_name   = "SITE_URL"
  value           = "https://${local.custom_Dev_domains}${var.domain_name}"
}