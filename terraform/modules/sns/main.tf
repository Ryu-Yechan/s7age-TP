resource "aws_sns_topic" "reservation_events" {
  name                        = "${var.env_name}feventtsqs.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
  display_name                = "STAGE"

}

# SNS Topic Subscription to SQS Queues
resource "aws_sns_topic_subscription" "reservedetail" {
  topic_arn = aws_sns_topic.reservation_events.arn

  protocol  = "sqs"
  endpoint  = var.sqs_reservedetail_arn
}

resource "aws_sns_topic_subscription" "ticketcreation" {
  topic_arn = aws_sns_topic.reservation_events.arn

  protocol  = "sqs"
  endpoint  = var.sqs_ticketcreation_arn
} 

/*
resource "aws_sns_topic_subscription" "lockrelease" {
  topic_arn = aws_sns_topic.reservation_events.arn

  protocol  = "sqs"
  endpoint  = var.sqs_lockrelease_arn
}

resource "aws_sns_topic_subscription" "statistics" {
  topic_arn = aws_sns_topic.reservation_events.arn
  protocol  = "sqs"
  endpoint  = var.sqs_statistics_arn
}

*/