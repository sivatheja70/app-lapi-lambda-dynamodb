/* output "API_GATEWAY_URL"{
  value = "${module.api_gateway.api_gw_url}/${var.path}"
}
output "Allowed_methods"{
    value = var.api_gateway_methods
} */

/* output cloudfront_distribution_id {
    value = "${module.cloudfront.cloudfront_distribution_id}"
} */
output cloudfront_distribution_domain_name {
    value = "${module.cloudfront.cloudfront_distribution_domain_name}"
}