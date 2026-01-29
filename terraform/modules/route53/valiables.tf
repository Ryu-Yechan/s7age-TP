variable "env_name" {
    type = string
}

variable "alb_dns_name" {
    
    type = string
    
}

variable "cloudfront_dns_name" {
    type = string
}


variable "custom_domains" {
  description = "Custom domain names for CloudFront"
  type        = string  
}


variable "domain_name" {
  type        = string
}

variable "dev_domain" {
  type        = string
}

