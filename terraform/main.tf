data "aws_caller_identity" "current" {}

module "alb" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0
  source             = "./modules/alb"
  vpc_id             = module.vpc[0].vpc_id
  alb_sg_id          = module.vpc[0].alb_sg_id
  public_subnet_a_id = module.vpc[0].public_subnet_a_id
  public_subnet_b_id = module.vpc[0].public_subnet_b_id
  master_instance_id = module.compute[0].master_instance_id


  worker_instances = {
    for idx, id in module.compute[0].worker_instance_ids :
      "worker${idx + 1}" => id
  }
    certificate_arn = "arn:aws:acm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:certificate/78698105-e675-4f31-a6ad-2dca3efb5d74"
    env_name = var.env_name 
 }



module "vpc" {
  source = "./modules/vpc"
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0
  env_name = var.env_name 
}

module "compute" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0
  source                    = "./modules/compute"
  private_subnet_a_id         = module.vpc[0].private_subnet_a_id
  private_subnet_b_id         = module.vpc[0].private_subnet_b_id
  node_sg_id                = module.vpc[0].k3s_node_sg_id
  stage_boangroup_id        = module.vpc[0].stage_boangroup_id
  key_name                  = "stage-rsa"
  iam_instance_profile_name = "k3s-ebs-role"
  env_name = var.env_name 
}





module "sqs" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0

  source = "./modules/sqs"
  env_name = var.env_name 
}

module "sns" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0
  source                 = "./modules/sns"
  sqs_reservedetail_arn  = module.sqs[0].reservedetail_queue_arn
  sqs_lockrelease_arn    = module.sqs[0].lockrelease_queue_arn
  sqs_ticketcreation_arn = module.sqs[0].ticketcreation_queue_arn
  sqs_statistics_arn     = module.sqs[0].statistics_queue_arn
  env_name = var.env_name 
}

module "elasticache" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "back"
  ) ? 1 : 0
  source            = "./modules/elasticache"
  subnet_ids       = [module.vpc[0].public_subnet_a_id, module.vpc[0].private_subnet_a_id, module.vpc[0].private_subnet_b_id, module.vpc[0].public_subnet_b_id]
  redis_sg_id      = module.vpc[0].redis_sg_id
  env_name = var.env_name 
}



module "iam" {
  count = terraform.workspace == "secret" ? 1 : 0
  source                         = "./modules/iam"
  ec2_role_name                  = "k3s-ebs-role"
  reuse_existing_role            = true
  existing_instance_profile_name = "k3s-ebs-role"
}


module "route53" {          
  domain_name                  = var.domain_name
  source                       = "./modules/route53"
  alb_dns_name                 = local.custom_alb   
  cloudfront_dns_name          = terraform.workspace == "back" ? null : module.cloudfront[0].distribution_domain_name
  custom_domains               = local.custom_domains[0]
  dev_domain                   = var.dev_domain
  env_name = var.env_name
  providers = {
    aws      = aws
    aws.east = aws.east
  }
}

module "waf" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "front"
  ) ? 1 : 0
  source        = "./modules/waf"
  env_name      = var.env_name
  providers = {
    aws      = aws
    aws.east = aws.east
  }
}

module "s3" {

  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "front"
  ) ? 1 : 0

  source = "./modules/s3"
  env_name = var.env_name 
}

module "cloudfront" {
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "front"  
  ) ? 1 : 0
  
  source                = "./modules/cloudfront"
  s3_bucket_domain_name = module.s3[0].bucket_domain_name
  s3_bucket_id          = module.s3[0].bucket_id
  s3_bucket_arn         = module.s3[0].bucket_arn
  web_acl_id            = module.waf[0].web_acl_id
  custom_domains        = local.custom_domains
  acm_certificate_arn   = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/111ec69d-fd7e-4be3-b4d4-a46882b23dec"
  env_name = var.env_name 
  providers = {
    aws      = aws
    aws.east = aws.east
  }
}

#export GITHUB_PAT=ghp_xxxxxxxxxxxxx 토큰 등록후 사용
module "github" {
  source                = "./modules/github"
  count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "front"  
  ) ? 1 : 0

  providers = {
    github = github
  }


  repository_name  = var.github_repo
  environment_name = local.github_env_name

  s3_bucket                  = module.s3[0].bucket_id
  cloudfront_distribution_id = module.cloudfront[0].distribution_id

  # 추가: OIDC/IAM 설정값
  github_owner      = var.github_owner

  allowed_branches     = ["dev"] # 개발중 추후 수정 필요 prod 타입 
  allowed_environments = ["DEV"] # 개발중 추후 수정 필요 prod 타입 
  domain_name           = var.domain_name
  dev_domain            = var.dev_domain
  iam_name_prefix   = "${var.env_name}-front-iac-iam"  
  site_name = lower(var.env_name)
  existing_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

