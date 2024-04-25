resource "aws_lambda_function" "lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  
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

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${local.lambda_name}_lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.api_lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_execution_iam_policy" {
  name   = "${local.lambda_name}_lambda_execution_iam"
  policy = data.aws_iam_policy_document.api_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  depends_on = [ aws_dynamodb_table.tasks ]
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_iam_policy.arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "${local.lambda_name}-AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_rest_api" "this" {
  name        = "${local.lambda_name}-APIGateway"
  description = "${local.lambda_name} API Gateway"
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_method.this
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "lambda"
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
  }
}

resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  policy      = data.aws_iam_policy_document.api_gw.json
}
