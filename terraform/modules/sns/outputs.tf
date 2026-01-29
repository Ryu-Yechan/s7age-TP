output "topic_arn" {
  value = aws_sns_topic.reservation_events.arn
}

output "topic_name" {
  value = aws_sns_topic.reservation_events.name
}

