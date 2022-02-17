# HTTP API
resource "random_id" "id" {
  byte_length = 8
}
resource "aws_apigatewayv2_api" "api" {
	name          = "api-${random_id.id.hex}"
  # name          = "api-specific-name"
	protocol_type = "HTTP"
	target        = aws_lambda_function.test_lambda.arn
}
# Permission
resource "aws_lambda_permission" "apigw" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.test_lambda.arn
	principal     = "apigateway.amazonaws.com"

	source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
