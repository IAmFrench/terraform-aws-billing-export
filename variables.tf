/* -------------------- S3 bucket to create the export in ------------------- */
variable "s3_bucket_name" {
  description = <<-EOT
  Name of the S3 bucket to be created
  E.g.: `finops-focus-export-a1b2c3d4`
  EOT

  type     = string
  nullable = false
}

/* ------ Option to create or not the S3 Bucket for the billing export ------ */
variable "create_s3_bucket" {
  description = <<-EOT
  Option to create or not the S3 bucket for the billing export.
  If set to `false`, this module will not create the S3 bucket.
  Therefore please check that bucket policies are sets to allow AWS export services to write files in it.
  More info: https://docs.aws.amazon.com/cur/latest/userguide/dataexports-s3-bucket.html

  E.g.: `true`, `false`
  EOT

  type     = bool
  default  = true
  nullable = false
}

/* ------------------------------- Export type ------------------------------ */
variable "export_type" {
  description = <<-EOT
  Version of the billing export.
  Valid values: `FOCUS` or `CUR`
  E.g.: `FOCUS` or `CUR` 
  EOT

  type     = string
  nullable = false

  validation {
    condition = contains([
      # FOCUS Export: 
      "FOCUS",

      # CUR Export:
      # Disabled as this module doesn't yet implement it
      # "CUR"
      ],
      var.export_type
    )
    error_message = "Unsupported export type. Only `FOCUS` and `CUR` export types are supported."
  }
}

/* ----------------------------- Export version ----------------------------- */
variable "export_version" {
  description = <<-EOT
  Version of the billing export. Should be use with `export_type`.
  Valid values are:
  - `1.0-preview` for FOCUS
  - `legacy` or `2.0` for CUR
  E.g.: `1.0-preview`, `legacy`, `2.0`
  EOT

  type     = string
  nullable = false

  validation {
    condition = contains([
      # FOCUS export type
      "1.0-preview",

      # CUR export type
      # Disabled as this module doesn't yet implement it
      #"legacy", 
      #"2.0"
      ],
      var.export_version
    )
    error_message = "Unsupported version. Please the check your `export_type` and the associated version. (E.g.: `1.0-preview` for FOCUS, `legacy` or `2.0` for CUR)"
  }
}

/* ------------------------------- Export Name ------------------------------ */
variable "export_name" {
  description = <<-EOT
  Name of the billing export. 
  Validation: Export name must be unique, not include spaces, and contain only alphanumeric and characters ! - _ . * ' ( )
  E.g.: `focus-v1-0-preview`
  EOT

  type     = string
  nullable = false
}

/* ---------------------------- Export S3 Prefix ---------------------------- */
variable "export_s3_prefix" {
  description = <<-EOT
  Prefix of the billing export.
  E.g.: `focus/123456789` with `123456789` being the account id
  EOT

  type     = string
  default  = ""
  nullable = false
}

/* ---------------------------------- Tags ---------------------------------- */
variable "tags" {
  description = <<-EOT
  Tags to apply to all created resources.
  E.g.:
  ```
  {
    createdBy = "Terraform"
  }
  ```
  EOT

  type     = map(string)
  default  = {}
  nullable = false
}
