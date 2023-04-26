output cloudfront_distribution_id {
    value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}