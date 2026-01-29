variable "env_name" {
  description = "Workspace name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_sg_id" {
  description = "Security Group ID for ALB"
}

variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
}

variable "public_subnet_b_id" {
  description = "Public Subnet B ID"
}

variable "certificate_arn" {
  description = "ACM Certificate ARN for HTTPS (optional)"
  type        = string
  default     = ""
}

variable "master_instance_id" {
  description = "Master instance ID"
}


variable "worker_instances" {
  type = map(string)
}