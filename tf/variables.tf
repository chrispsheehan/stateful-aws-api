variable "region" {
  type        = string
  description = "The AWS Region to use"
  default     = "eu-west-2"
}

variable "function_name" {
  type        = string
  description = "Name of the lambda function"
  default     = "stateful-aws-api"
}

variable "lambda_zip_path" {
  type        = string
  description = "Lambda code (zipped) to be deployed"
}
