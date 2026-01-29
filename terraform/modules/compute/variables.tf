variable "env_name" {
  description = "Workspace name"
  type        = string
}


variable "private_subnet_a_id" {
  type        = string
}
variable "private_subnet_b_id" {
  type        = string
}

variable "ami_id" {
  default = "ami-010be25c3775061c9"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "AWS에 등록된 키 페어 이름"
  default     = "stage-rsa"
}

variable "iam_instance_profile_name" {
  description = "IAM Instance Profile name for EC2 instances"
  type        = string
  default     = ""
}

variable "node_sg_id" {
  description = "Security group ID for k3s nodes"
  type        = string
}

variable "stage_boangroup_id" {
  description = "stage-boangroup created 2025-12-15T02:42:03.017Z"
  type        = string
}

variable "worker_roles" {
  type = map(string)
  default = {
    "worker2" = "monitoring"
    "worker3" = "db"
  }
}