output "s3_bucket" {
  value = aws_s3_bucket.origin.bucket
}
output "cfn" {
  value = aws_cloudfront_distribution.this
}
