locals {
  lambda_runtime      = "nodejs18.x"
  lambda_name         = "${var.function_name}-lambda"
  lambda_bucket       = "${local.lambda_name}-bucket"
  dynamodb_table_name = "${local.lambda_name}-db"
  dynamodb_endpoint   = "https://dynamodb.${var.region}.amazonaws.com"
}
