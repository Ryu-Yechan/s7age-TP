data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.env_name}-s3-oac-s7age-frontend"
  description                       = "${var.env_name} Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  web_acl_id          = var.web_acl_id
  aliases             = var.custom_domains
  

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = var.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_id

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id


    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:function/strip-bypass-headers"
    }

    function_association {
      event_type   = "viewer-response"
      function_arn = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:function/add-csp-headers"
    }

    compress               = true
  }

  # Custom Error Response
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    ssl_support_method       = var.acm_certificate_arn != "" ? "sni-only" : "vip"
    minimum_protocol_version = var.acm_certificate_arn != "" ? "TLSv1.3_2025" : "TLSv1"
    
  }

  depends_on = [aws_cloudfront_origin_access_control.s3_oac]
  tags = {
    Name = "${var.env_name}-s7age-frontend"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend.arn
          }
        }
      }
    ]
  })
}

