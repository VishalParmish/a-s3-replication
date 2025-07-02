module "artifact_bucket" {
  source        = "../modules/s3-bucket"
  bucket_prefix = "artifact-bucket"
}
