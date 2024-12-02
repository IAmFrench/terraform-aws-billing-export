# Amazon Web Services (AWS) Billing export Terraform Module

Terraform module witch creates billing export on AWS.

FOCUS v1.0 billing export for AWS now available!

This module will create S3 bucket for AWS billing exports.

## What is FOCUS™?

The FinOps Cost and Usage Specification (FOCUS™) is an open-source specification that defines clear requirements for cloud vendors to produce consistent cost and usage datasets.

Supported by the FinOps Foundation, FOCUS™ aims to reduce complexity for FinOps Practitioners so they can drive data-driven decision-making and maximize the business value of cloud, while making their skills more transferable across clouds, tools, and organizations.

Learn more about FOCUS in this [FinOps Foundation Insights article](https://www.finops.org/insights/focus-1-0-available/).

## Usage

```terraform
# FOCUS v1.0 AWS billing export with the creation of the S3 bucket
module "aws_billing_export" {
  source  = "IAmFrench/billing-export/aws"

  # Version of this module, see release on GitHub: https://github.com/IAmFrench/terraform-aws-billing-export/releases
  version = "1.0.4"
  
  # Name of the S3 bucket to create exports in
  s3_bucket_name   = "finops-exports-1a2b3c4d"
  # Type of the export
  export_type      = "FOCUS"
  # Version of the export
  export_version   = "1.0"
  # Name of the export
  export_name      = "focus-export"
  # Prefix of the export
  export_s3_prefix = "focus/1234556789"
}
```

```terraform
# FOCUS v1.0 AWS billing export with an existing S3 bucket
module "aws_billing_export" {
  source  = "IAmFrench/billing-export/aws"

  # Version of this module, see release on GitHub: https://github.com/IAmFrench/terraform-aws-billing-export/releases
  version = "1.0.4"
  
  # Name of the S3 bucket to create exports in
  s3_bucket_name   = data.aws_s3_bucket.export.id
  # Should this module create the S3 bucket with associated policy?
  create_s3_bucket = false
  # Type of the export
  export_type      = "FOCUS"
  # Version of the export
  export_version   = "1.0"
  # Name of the export
  export_name      = "focus-export"
  # Prefix of the export
  export_s3_prefix = "focus/1234556789"
}
```
## Roadmap

- [X] FOCUS `v1.0` export [Data Exports for FOCUS 1.0 is now in general availability](https://aws.amazon.com/blogs/aws-cloud-financial-management/data-exports-for-focus-1-0-is-now-generally-available/) 
- [X] FOCUS `v1.0-preview` export [Announcing Data Exports for FOCUS 1.0 (Preview) in AWS Billing and Cost Management](https://aws.amazon.com/blogs/aws-cloud-financial-management/announcing-data-exports-for-focus-1-0-preview-in-aws-billing-and-cost-management/)
- [ ] CUR `v2` export [Introducing Data Exports for AWS Billing and Cost Management](https://aws.amazon.com/blogs/aws-cloud-financial-management/introducing-data-exports-for-billing-and-cost-management/)
- [ ] CUR `legacy` export [Creating a Legacy CUR export](https://docs.aws.amazon.com/cur/latest/userguide/dataexports-create-legacy.html)

## Common errors

- `ValidationException: S3 bucket permission validation failed`: The existing S3 bucket is missing the policy to allow AWS export services to write to the bucket, see https://docs.aws.amazon.com/cur/latest/userguide/dataexports-s3-bucket.html

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_bcmdataexports_export.focus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bcmdataexports_export) | resource |
| [aws_s3_bucket.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_data_export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_data_export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Option to create or not the S3 bucket for the billing export.<br>If set to `false`, this module will not create the S3 bucket.<br>Therefore please check that bucket policies are sets to allow AWS export services to write files in it.<br>More info: https://docs.aws.amazon.com/cur/latest/userguide/dataexports-s3-bucket.html<br><br>E.g.: `true`, `false` | `bool` | `true` | no |
| <a name="input_export_name"></a> [export\_name](#input\_export\_name) | Name of the billing export. <br>Validation: Export name must be unique, not include spaces, and contain only alphanumeric and characters ! - \_ . * ' ( )<br>E.g.: `focus-v1-0-preview` | `string` | n/a | yes |
| <a name="input_export_s3_prefix"></a> [export\_s3\_prefix](#input\_export\_s3\_prefix) | Prefix of the billing export.<br>E.g.: `focus/123456789` with `123456789` being the account id | `string` | `""` | no |
| <a name="input_export_type"></a> [export\_type](#input\_export\_type) | Version of the billing export.<br>Valid values: `FOCUS` or `CUR`<br>E.g.: `FOCUS` or `CUR` | `string` | n/a | yes |
| <a name="input_export_version"></a> [export\_version](#input\_export\_version) | Version of the billing export. Should be use with `export_type`.<br>Valid values are:<br>- `1.0` and `1.0-preview` for FOCUS<br>- `legacy` or `2.0` for CUR<br>E.g.: `1.0`, `1.0-preview`, `legacy`, `2.0` | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket to be created<br>E.g.: `finops-focus-export-a1b2c3d4` | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all created resources.<br>E.g.:<pre>{<br>  createdBy = "Terraform"<br>}</pre> | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_export_arn"></a> [export\_arn](#output\_export\_arn) | ARN of the export |
| <a name="output_s3_arn"></a> [s3\_arn](#output\_s3\_arn) | ARN of the export bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
