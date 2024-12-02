# FOCUS v1.0-preview billing export without S3 bucket

This example will create a AWS FOCUS billing export to an existing S3 bucket.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_billing_export"></a> [aws\_billing\_export](#module\_aws\_billing\_export) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.export](https://registry.terraform.io/providers/hashicorp/aws/5.47.0/docs/data-sources/s3_bucket) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
