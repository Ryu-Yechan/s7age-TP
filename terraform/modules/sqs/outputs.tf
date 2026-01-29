output "reservedetail_queue_arn" {
  value = aws_sqs_queue.reservedetail.arn
}

output "reservedetail_queue_url" {
  value = aws_sqs_queue.reservedetail.url
}

output "lockrelease_queue_arn" {
  value = aws_sqs_queue.lockrelease.arn
}

output "lockrelease_queue_url" {
  value = aws_sqs_queue.lockrelease.url
}

output "ticketcreation_queue_arn" {
  value = aws_sqs_queue.ticketcreation.arn
}

output "ticketcreation_queue_url" {
  value = aws_sqs_queue.ticketcreation.url
}

output "statistics_queue_arn" {
  value = aws_sqs_queue.statistics.arn
}

output "statistics_queue_url" {
  value = aws_sqs_queue.statistics.url
}

