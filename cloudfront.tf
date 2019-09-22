resource "aws_cloudfront_origin_access_identity" "this" {
  comment = var.comment
}

data "aws_iam_policy_document" "origin" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::$${bucket_name}$${origin_path}*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::$${bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}
resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class

  aliases = var.aliases

  origin {
    domain_name = aws.aws_s3_bucket.origin.bucket"."aws.aws_s3_bucket.origin.bucket.selected.region".s3.amazonaws.com"
    origin_id   =  aws_s3_bucket.origin.bucket
    # origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.minimum_protocol_version
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = aws_s3_bucket.origin.bucket
    compress         = var.compress
    trusted_signers  = var.trusted_signers

    forwarded_values {
      query_string = var.forward_query_string
      headers      = var.forward_header_values

      cookies {
        forward = var.forward_cookies
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    default_ttl            = var.default_ttl
    min_ttl                = var.min_ttl
    max_ttl                = var.max_ttl
    
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }
  logging_config {
    include_cookies = false
    bucket          = var.logging_bucket[var.stage]
    prefix          = aws_s3_bucket.origin.bucket
  }
  custom_error_response {
       error_code          = 403
      response_code      = 200
      response_page_path  = "/index.html"
    }
  custom_error_response {
       error_code          = 404
      response_code      = 200
      response_page_path  = "/index.html"
    }
