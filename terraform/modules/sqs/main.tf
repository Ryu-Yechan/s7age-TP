resource "aws_sqs_queue" "lockrelease" {
  name                        = "${var.env_name}reservation-lockrelease.fifo"
  max_message_size            = 1048576
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "reservedetail" {
  name                        = "${var.env_name}reservation-reservedetail.fifo"
  max_message_size            = 1048576
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "statistics" {
  name                        = "${var.env_name}reservation-statistics.fifo"
  max_message_size            = 1048576
  fifo_queue                  = true
  content_based_deduplication = true
}


resource "aws_sqs_queue" "ticketcreation" {
  name                        = "${var.env_name}reservation-ticketcreation.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  max_message_size            = 1048576
}

resource "aws_sqs_queue_policy" "reservedetail" {
  queue_url = aws_sqs_queue.reservedetail.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Sid    = "__owner_statement"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "SQS:*"
        Resource = aws_sqs_queue.reservedetail.arn
      },
      {
        Sid    = "topic-subscription-arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "SQS:SendMessage"
        Resource = aws_sqs_queue.reservedetail.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "lockrelease" {
  queue_url = aws_sqs_queue.lockrelease.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Sid    = "__owner_statement"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "SQS:*"
        Resource = aws_sqs_queue.lockrelease.arn
      },
      {
        Sid    = "topic-subscription-arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "SQS:SendMessage"
        Resource = aws_sqs_queue.lockrelease.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "ticketcreation" {
  queue_url = aws_sqs_queue.ticketcreation.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Sid    = "__owner_statement"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "SQS:*"
        Resource = aws_sqs_queue.ticketcreation.arn
      },
      {
        Sid    = "topic-subscription-arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "SQS:SendMessage"
        Resource = aws_sqs_queue.ticketcreation.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
          }
        }
      }
    ]
  })
}



resource "aws_sqs_queue_policy" "statistics" {
  queue_url = aws_sqs_queue.statistics.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Sid    = "__owner_statement"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "SQS:*"
        Resource = aws_sqs_queue.statistics.arn
      },
      {
        Sid    = "topic-subscription-arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "SQS:SendMessage"
        Resource = aws_sqs_queue.statistics.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:feventtsqs.fifo"
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
