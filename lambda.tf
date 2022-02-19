
locals {
    lambda_zip_location = "outputs/db-call.zip"
}

data "archive_file" "db-call" {
  type        = "zip"
  source_file = "db-call.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "lambda_func" {
  filename      = "${local.lambda_zip_location}"
  function_name = "db-call"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "db-call.lambda_handler"
  source_code_hash = "${filebase64sha256(local.lambda_zip_location)}"
  runtime = "python3.8"

}