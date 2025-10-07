variable "region" {
  description = "Região AWS onde o bucket será criado"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "terraform-pijvsellpeline-test-bucket"
}
