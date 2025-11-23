locals {
  region = "eu-west-3" # Europe (Paris)

  s3_bucket_name = "finops-exports-fdxfttyp"
  export_type    = "FOCUS"

  exports = [
    "1.2",
    "1.0",
    "1.0-preview",
  ]
}

module "aws_billing_export" {
  source = "../../"

  for_each = { for v in local.exports : v => v }

  # Name of the S3 bucket to create exports in
  s3_bucket_name = local.s3_bucket_name
  # Should this module create the S3 bucket with associated policy?
  create_s3_bucket = false
  # Type of the export
  export_type = local.export_type
  # Version of the export
  export_version = each.value
  # Name of the export
  export_name = "finops-focus-${replace(each.value, ".", "-")}-export"
  # Prefix of the export
  export_s3_prefix = "focus/v${each.value}/1234556789"

  # Force destroy the S3 bucket when the module is destroyed event if it contains objects
  s3_force_destroy = true
}
