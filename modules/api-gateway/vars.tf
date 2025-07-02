variable "api_name" {}
variable "description" {}
variable "lambda_invoke_arn" {}
variable "lambda_function_name" {}
variable "stage_name" {
  default = "dev"
}
variable "region" {
  default = "us-east-1"
}

