 output "API_GATEWAY_URL"{
  value = "${module.api_gateway.api_gw_url}"
}

output cloudfront_distribution_domain_name {
    value = "${module.cloudfront.cloudfront_distribution_domain_name}"
}