data "aws_s3_bucket" "s3_cloudfront" {
  bucket = "sivatheja-zapcg"
}

/* provisioner "local-exec" {
  command = "aws s3 cp ./profile.html/ s3://${aws_s3_bucket.sivatheja-zapcg.bucket}/ --recursive"
} */


##############################################################################################
resource "aws_cloudfront_origin_access_control" "s3_origin" {
  name                              = data.aws_s3_bucket.s3_cloudfront.bucket_domain_name
  description                       = "s3_access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" { 
origin {
    domain_name = data.aws_s3_bucket.s3_cloudfront.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin.id
    origin_id   = var.origin_id
}
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "internaltask"
  default_root_object = var.default_root_object
default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id
forwarded_values {
      query_string = false
cookies {
        forward = "none"
      }
    }
viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
# Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.origin_id
forwarded_values {
      query_string = false
      headers      = ["Origin"]
cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = false
    viewer_protocol_policy = "allow-all"
  }
# Cache behavior with precedence 1
  /* ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id  = var.origin_id
forwarded_values {
      query_string = false
cookies {
        forward = "none"
      }
    }
min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress             = true
    viewer_protocol_policy = "redirect-to-https"
  } */

price_class = "PriceClass_200"
restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "IN"]
    }
  }
tags = {
    Environment = "var.environment"
  }
viewer_certificate {
    cloudfront_default_certificate = true
  }
}