variable "env_name" {
  description = "Workspace name"
  type        = string
}

variable "sqs_reservedetail_arn" {
  description = "SQS Queue ARN for reservation-reservedetail.fifo"
}

variable "sqs_lockrelease_arn" {
  description = "SQS Queue ARN for reservation-lockrelease.fifo"
}

variable "sqs_ticketcreation_arn" {
  description = "SQS Queue ARN for reservation-ticketcreation.fifo"
}

variable "sqs_statistics_arn" {
  description = "SQS Queue ARN for reservation-statistics.fifo"
}

