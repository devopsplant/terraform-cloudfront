resource "aws_s3_bucket" "origin" {
  bucket        = var.origin_bucket
  acl           = "private"
  force_destroy = var.origin_force_destroy
  region        = data.aws_region.current.name
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = sort(
      distinct(compact(concat(var.cors_allowed_origins, var.aliases))),
    )
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}
