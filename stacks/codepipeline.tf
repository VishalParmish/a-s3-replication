module "codepipeline" {
  source           = "../modules/codepipeline"
  pipeline_name    = "example-pipeline-1"
  artifact_bucket  = module.artifact_bucket.bucket_name
  connection_arn   = "arn:aws:codeconnections:us-east-1:975050191688:connection/30711670-72ef-46d5-9c9e-e89e98578f76"
  repo_id          = "VishalAerinIt/lambda-function"
  branch           = "master"
  project_name     = "example-build-project-1"
  buildspec_path   = "buildspec.yml"
}
