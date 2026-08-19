output "bucket_id" {
  description = "bucked id for referencing"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "bucked arn for referencing"
  value       = aws_s3_bucket.main.arn
}