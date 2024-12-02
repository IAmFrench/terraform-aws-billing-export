output "export_arn" {
  description = "ARN of the export"
  value       = aws_bcmdataexports_export.focus[0]
}

output "s3_arn" {
  description = "ARN of the export bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.export[0].arn : data.aws_s3_bucket.export[0].arn
}
