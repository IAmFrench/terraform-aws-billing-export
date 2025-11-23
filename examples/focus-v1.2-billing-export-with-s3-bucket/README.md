# FOCUS v1.2 billing export with S3 bucket

This example will create a AWS FOCUS billing export and the corresponding S3 bucket.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_billing_export"></a> [aws\_billing\_export](#module\_aws\_billing\_export) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
