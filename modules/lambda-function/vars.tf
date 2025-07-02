variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "s3_bucket" {}
variable "s3_key" {}
variable "timeout" {
  default = 10
}
variable "memory_size" {
  default = 128
}
