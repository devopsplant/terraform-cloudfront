resource "random_string" "tracking" {
  length  = 8
  special = false
  upper   = false
}
data "aws_region" "current" {
}