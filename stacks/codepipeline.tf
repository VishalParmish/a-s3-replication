module "codepipeline" {
  source           = "../modules/codepipeline"
  pipeline_name    = "example-pipeline-1"
  artifact_bucket  = module.artifact_bucket.bucket_name
  connection_arn   = var.connection_arn
  repo_id          = var.repo_id
  branch           = var.branch
  project_name     = "example-build-project-1"
  buildspec_path   = "buildspec.yml"
}
