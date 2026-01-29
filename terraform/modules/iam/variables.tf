variable "ec2_role_name" {
  description = "EC2 역할 이름"
  type        = string
  default     = ""
}

variable "reuse_existing_role" {
  description = "기존 역할 재사용 여부"
  type        = bool
  default     = true  # 기존 EC2-SSM-Role 사용
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}

variable "sqs_reservedetail_arn" {
  type    = string
  default = ""
}

variable "sqs_lockrelease_arn" {
  type    = string
  default = ""
}

variable "sqs_ticketcreation_arn" {
  type    = string
  default = ""
}

variable "sqs_statistics_arn" {
  type    = string
  default = ""
}


variable "existing_instance_profile_name" {
  description = "기존 EC2 instance profile 이름"
  type        = string
  default     = ""
}