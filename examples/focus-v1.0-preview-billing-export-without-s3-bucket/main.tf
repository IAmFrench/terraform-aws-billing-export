data "aws_s3_bucket" "export" {
  bucket = "finops-exports-1a2b3c4d"
}

locals {
  region = "eu-west-3" # Europe (Paris)

  s3_bucket_name   = data.aws_s3_bucket.export.id
  export_type      = "FOCUS"
  export_version   = "1.0-preview"
  export_name      = "focus-1-0-preview-export-bis"
  export_s3_prefix = "focus/v1.0-preview-bis/1234556789"
}

module "aws_billing_export" {
  source = "../../"

  # Name of the S3 bucket to create exports in
  s3_bucket_name = local.s3_bucket_name
  # Should this module create the S3 bucket with associated policy?
  create_s3_bucket = false
  # Type of the export
  export_type = local.export_type
  # Version of the export
  export_version = local.export_version
  # Name of the export
  export_name = local.export_name
  # Prefix of the export
  export_s3_prefix = local.export_s3_prefix
}
