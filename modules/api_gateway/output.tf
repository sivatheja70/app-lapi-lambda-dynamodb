output "api_gw_url" {


  value = aws_api_gateway_deployment.productapistageprod.invoke_url
}
