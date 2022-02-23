
# API Gateway
resource "aws_apigatewayv2_api" "api" {
 	name          = "my-api"
	protocol_type = "HTTP"
	target        = aws_lambda_function.lambda_func.arn
	cors_configuration {
		allow_origins = ["*"]
	}
}

# Integration
resource "aws_apigatewayv2_integration" "integration" {
  api_id            = aws_apigatewayv2_api.api.id
  integration_type  = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.lambda_func.invoke_arn
}

# Permission
resource "aws_lambda_permission" "apigw" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda_func.arn
	principal     = "apigateway.amazonaws.com"
	source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}


