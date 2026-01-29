data "aws_lb" "front_alb" {
  name = "stageALB"  # 실제 ALB 이름#${var.env_name}
}

locals {
  is_prod = terraform.workspace == "prod"
  is_front = terraform.workspace == "front"

  custom_domains = local.is_prod ? [var.domain_name, "www.${var.domain_name}"] : ["${var.dev_domain}.${var.domain_name}"]
  custom_alb = local.is_front ? data.aws_lb.front_alb.dns_name : try(module.alb[0].alb_dns_name, null) #테스트 끝나면 prod로 바꿀것
  github_env_name = terraform.workspace == "prod" ? "PROD" : "DEV"
}