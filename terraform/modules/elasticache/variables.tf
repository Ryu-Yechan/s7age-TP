variable "env_name" {
  description = "Workspace name"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "redis_sg_id" {
  type = string
}



