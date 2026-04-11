output "api_gateway_endpoint" {
  description = "API Gateway HTTP endpoint (visitor counter)"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "www_cloudfront_domain" {
  description = "CloudFront domain for www distribution"
  value       = aws_cloudfront_distribution.www_s3_distribution.domain_name
}

output "root_cloudfront_domain" {
  description = "CloudFront domain for root redirect distribution"
  value       = aws_cloudfront_distribution.root_s3_distribution.domain_name
}

output "website_url" {
  description = "Live website URL"
  value       = "https://www.${var.domain_name}"
}