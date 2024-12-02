/* -------------------------------------------------------------------------- */
/*                             AWS billing export                             */
/* -------------------------------------------------------------------------- */

/* -------------------------- Billing export bucket ------------------------- */
resource "aws_s3_bucket" "export" {
  # Create the s3 bucket only if var.create_s3_bucket is true
  count  = var.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_name

  tags = var.tags
}

/* --------------------------- Current account id --------------------------- */
# This is used to set s3 bucket policy
data "aws_caller_identity" "current" {}

/* -------------------- S3 bucket policy for data export -------------------- */
# https://docs.aws.amazon.com/cur/latest/userguide/dataexports-s3-bucket.html
resource "aws_s3_bucket_policy" "allow_data_export" {
  # Create the s3 bucket policy only if var.create_s3_bucket is true
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.export[0].id
  policy = data.aws_iam_policy_document.allow_data_export[0].json
}

data "aws_iam_policy_document" "allow_data_export" {
  # Create the policy only if var.create_s3_bucket is true
  count = var.create_s3_bucket ? 1 : 0
  statement {
    sid    = "EnableAWSDataExportsToWriteToS3AndCheckPolicy"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "billingreports.amazonaws.com",
        "bcm-data-exports.amazonaws.com"
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetBucketPolicy",
    ]

    resources = [
      aws_s3_bucket.export[0].arn,
      "${aws_s3_bucket.export[0].arn}/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:SourceAccount"

      values = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:cur:us-east-1:${data.aws_caller_identity.current.account_id}:definition/*",
        "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/*"
      ]
    }
  }
}

data "aws_s3_bucket" "export" {
  # The bucket exist only if var.create_s3_bucket is false
  count = var.create_s3_bucket ? 0 : 1

  bucket = var.s3_bucket_name
}

locals {
  s3_bucket = {
    name   = var.create_s3_bucket ? aws_s3_bucket.export[0].bucket : data.aws_s3_bucket.export[0].bucket
    region = var.create_s3_bucket ? aws_s3_bucket.export[0].region : data.aws_s3_bucket.export[0].region
  }
  export_version = {
    # FOCUS 1.0 GA 
    # learn more: https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws.html
    "1.0" = {
      "query" = "SELECT AvailabilityZone, BilledCost, BillingAccountId, BillingAccountName, BillingCurrency, BillingPeriodEnd, BillingPeriodStart, ChargeCategory, ChargeClass, ChargeDescription, ChargeFrequency, ChargePeriodEnd, ChargePeriodStart, CommitmentDiscountCategory, CommitmentDiscountId, CommitmentDiscountName, CommitmentDiscountStatus, CommitmentDiscountType, ConsumedQuantity, ConsumedUnit, ContractedCost, ContractedUnitPrice, EffectiveCost, InvoiceIssuerName, ListCost, ListUnitPrice, PricingCategory, PricingQuantity, PricingUnit, ProviderName, PublisherName, RegionId, RegionName, ResourceId, ResourceName, ResourceType, ServiceCategory, ServiceName, SkuId, SkuPriceId, SubAccountId, SubAccountName, Tags, x_CostCategories, x_Discounts, x_Operation, x_ServiceCode, x_UsageType FROM FOCUS_1_0_AWS"
    }

    # FOCUS 1.0 (Preview)
    # Learn more: https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws-preview.html
    "1.0-preview" = {
      "query" = "SELECT AvailabilityZone, BilledCost, BillingAccountId, BillingAccountName, BillingCurrency, BillingPeriodEnd, BillingPeriodStart, ChargeCategory, ChargeClass, ChargeDescription, ChargeFrequency, ChargePeriodEnd, ChargePeriodStart, CommitmentDiscountCategory, CommitmentDiscountId, CommitmentDiscountName, CommitmentDiscountType, CommitmentDiscountStatus, ConsumedQuantity, ConsumedUnit, ContractedCost, ContractedUnitPrice, EffectiveCost, InvoiceIssuerName, ListCost, ListUnitPrice, PricingCategory, PricingQuantity, PricingUnit, ProviderName, PublisherName, RegionId, RegionName, ResourceId, ResourceName, ResourceType, ServiceCategory, ServiceName, SkuId, SkuPriceId, SubAccountId, SubAccountName, Tags, x_CostCategories, x_Discounts, x_Operation, x_ServiceCode, x_UsageType FROM FOCUS_1_0_AWS_PREVIEW"
    }
  }
}

/* ------------------------------ FOCUS export ------------------------------ */
# Config adapted from https://github.com/aws-samples/aws-cudos-framework-deployment/blob/cd2363e070b29ac4036b92919f863314aa15856e/cfn-templates/data-exports-aggregation.yaml#L516
resource "aws_bcmdataexports_export" "focus" {
  # Only create this export if the export_type is FOCUS
  count = var.export_type == "FOCUS" ? 1 : 0

  export {
    name = var.export_name
    data_query {
      query_statement = local.export_version[var.export_version].query
    }
    description = "FOCUS export"
    destination_configurations {
      s3_destination {
        s3_bucket = local.s3_bucket.name
        s3_prefix = var.export_s3_prefix
        s3_region = local.s3_bucket.region
        s3_output_configurations {
          overwrite   = "OVERWRITE_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }

    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }

  tags = var.tags
}
