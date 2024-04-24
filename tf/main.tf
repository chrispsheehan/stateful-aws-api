resource "aws_iam_policy" "api_lambda_policy" {
  name        = "${local.lambda_name}_api_policy"
  description = "IAM policy to allow Lambda function to read parameter from SSM"

  policy = data.aws_iam_policy_document.api_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "api_lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.api_lambda_policy.arn
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${local.lambda_name}_lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.api_lambda_assume_role.json
}

resource "aws_lambda_permission" "this" {
  statement_id  = "${local.lambda_name}_AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
}


resource "aws_lambda_function" "lambda" {
  filename      = var.lambda_zip_path
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.handler"
  runtime       = "nodejs20.x"
  timeout       = 10

  environment {
    variables = {
      DYNAMODB_REGION       = var.region
      DYNAMODB_TABLE        = local.dynamodb_table_name
      DYNAMODB_ENDPOINT     = local.dynamodb_endpoint
    }
  }
}

resource "aws_dynamodb_table" "tasks" {
  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "title"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "title"
    type = "S"
  }
 
  global_secondary_index {
    name            = "title_index"
    hash_key        = "title"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }
}

resource "aws_apigatewayv2_api" "this" {
  name          = "${local.lambda_name}-APIGateway"
  protocol_type = "HTTP"
  target        = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "lambda"
  auto_deploy = false
}