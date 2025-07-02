module "lambda" {
  source          = "../modules/lambda-function"
  function_name   = "example_lambda"
  handler         = "index.handler"
  runtime         = "nodejs20.x"
  s3_bucket       = module.artifact_bucket.bucket_name
  s3_key          = "lambda.zip"
  timeout         = 10
  memory_size     = 128
}
