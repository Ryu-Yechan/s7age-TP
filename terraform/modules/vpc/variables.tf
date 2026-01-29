variable "env_name" {
  description = "Workspace name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "private_a_cidr" {
  description = "Private Subnet A CIDR block"
  default     = "10.0.0.0/24"
}
variable "private_b_cidr" {
  description = "Private Subnet B CIDR block"
  default     = "10.0.3.0/24" #나중에 추가
}

variable "public_a_cidr" {
  description = "Public Subnet A CIDR block"
  default     = "10.0.1.0/24"
}

variable "public_b_cidr" {
  description = "Public Subnet B CIDR block"
  default     = "10.0.2.0/24"
}