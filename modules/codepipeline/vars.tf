variable "pipeline_name" {}
variable "artifact_bucket" {}
variable "repo_id" {}
variable "branch" {}
variable "connection_arn" {}
variable "project_name" {}
variable "buildspec_path" {}
variable "codebuild_image" {
  default = "aws/codebuild/standard:5.0"
}
