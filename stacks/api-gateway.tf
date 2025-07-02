module "api_gateway" {
  source               = "../modules/api-gateway"
  api_name             = "example-api"
  description          = "API Gateway for Lambda"
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
  region = var.region
}
