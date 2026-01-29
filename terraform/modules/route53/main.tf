locals {
  is_prod = terraform.workspace == "prod"
  custom_Dev_domains = local.is_prod ? "" : var.dev_domain


  
}

resource "aws_route53_record" "a_rec" {
    count = (
    terraform.workspace == "prod" ||
    terraform.workspace == "dev"  ||
    terraform.workspace == "front"
  ) ? 1 : 0
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}.${var.domain_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = var.cloudfront_dns_name  
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}




resource "aws_route53_record" "cname_rec" {
  count = terraform.workspace == "is_prod" ? 1 : 0
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "_ac5ab6046a8a80e8de0b7bdfeee410b2.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  allow_overwrite = true
  lifecycle {
    prevent_destroy = true
  }
  records = ["_69a6faad2fca838c915a7180894ec2d7.jkddzztszm.acm-validations.aws."]
}


resource "aws_route53_record" "soa_rec" {
  count = terraform.workspace == "is_prod" ? 1 : 0
  zone_id = "Z02048853UUVU223ANKAS"
  name    = var.domain_name
  type    = "SOA"
  ttl     = 900
  allow_overwrite = true

  records = [
    "ns-195.awsdns-24.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "ns_rec" {
  count = terraform.workspace == "is_prod" ? 1 : 0
  zone_id = "Z02048853UUVU223ANKAS"
  name    = var.domain_name
  type    = "NS"
  ttl     = 172800
  allow_overwrite = true

  records = [
    "ns-195.awsdns-24.com.",
    "ns-1906.awsdns-46.co.uk.",
    "ns-765.awsdns-31.net.",
    "ns-1499.awsdns-59.org."
  ]
}


# API 레코드
resource "aws_route53_record" "api" {
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}api.${var.domain_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = false
  }
}

# Grafana 레코드
resource "aws_route53_record" "grafana" {
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}grafana.${var.domain_name}"
  type    = "A"
  allow_overwrite = true


  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = true
  }
}

# Prometheus 레코드
resource "aws_route53_record" "prometheus" {
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}prometheus.${var.domain_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = true
  }
}

# Argocd 레코드
resource "aws_route53_record" "argocd" {
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}argocd.${var.domain_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = true
  }
}

# Alert 레코드
resource "aws_route53_record" "alert" {
  zone_id = "Z02048853UUVU223ANKAS"
  name    = "${local.custom_Dev_domains}alert.${var.domain_name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = true
  }
}