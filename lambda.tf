data "archive_file" "dbcall" {
  type        = "zip"
  source_file = "dbcall.py"
  output_path = "outputs/dbcall.zip"
}

resource "aws_lambda_function" "lambda_func" {
  filename         = data.archive_file.dbcall.output_path
  function_name    = "dbcall"
  role             = aws_iam_role.lambda_role.arn
  handler          = "dbcall.lambda_handler"
  source_code_hash = data.archive_file.dbcall.output_base64sha256
  runtime          = "python3.11"
  timeout          = 10
  memory_size      = 128

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.dynamodbtable.name
    }
  }
}