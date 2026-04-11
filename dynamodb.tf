resource "aws_dynamodb_table" "dynamodbtable" {
  name           = "counter"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "tableitem" {
  table_name = aws_dynamodb_table.dynamodbtable.name
  hash_key   = aws_dynamodb_table.dynamodbtable.hash_key
  item       = jsonencode({ id = { N = "0" }, visitcount = { N = "0" } })

  lifecycle {
    ignore_changes = [item]
  }
}