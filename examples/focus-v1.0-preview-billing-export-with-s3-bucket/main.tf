locals {
  region = "eu-west-3" # Europe (Paris)

  s3_bucket_name   = "finops-exports-${random_string.bucket.id}"
  export_type      = "FOCUS"
  export_version   = "1.0-preview"
  export_name      = "focus-1-0-preview-export"
  export_s3_prefix = "focus/v1.0-preview/1234556789"
}

resource "random_string" "bucket" {
  length  = 8
  special = false
  upper   = false
}

module "aws_billing_export" {
  source = "../../"

  # Name of the S3 bucket to create exports in
  s3_bucket_name = local.s3_bucket_name
  # Type of the export
  export_type = local.export_type
  # Version of the export
  export_version = local.export_version
  # Name of the export
  export_name = local.export_name
  # Prefix of the export
  export_s3_prefix = local.export_s3_prefix
  # Force destroy the S3 bucket when the module is destroyed event if it contains objects
  s3_force_destroy = true
}
