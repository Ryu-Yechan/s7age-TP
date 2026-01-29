variable "env_name" {

  type        = string
}

variable "domain_name" {
  type        = string
}

variable "waf_enabled" {
  type    = bool
  default = true  # 기본적으로 활성화
}

variable "iam_enabled" {
  type    = bool
  default = true  # 기본적으로 활성화
}


variable "github_owner" {
  type = string
  default = "S7AGE"
}

variable "github_repo" {
  type        = string
  default = "Front"
}


variable "dev_domain" {
  type        = string
}

