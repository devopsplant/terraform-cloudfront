variable "enabled" {
  type        = bool
  default     = true
  description = "Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created."
}
variable "is_ipv6_enabled" {
  type        = bool
  default     = true
  description = "State of CloudFront IPv6"
}
variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Object that CloudFront return when requests the root URL"
}
variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
}
variable "log_include_cookies" {
  type        = bool
  default     = false
  description = "Include cookies in access logs"
}
variable "log_prefix" {
  type        = string
  default     = ""
  description = "Path of logs in S3 bucket"
}

variable "aliases" {
  type        = list(string)
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront"
  default     = []
}
variable "cors_allowed_methods" {
  type        = list(string)
  default     = ["GET"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for S3 bucket"
}
variable "cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)"
}

variable "default_ttl" {
  default     = 60
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}
variable "min_ttl" {
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}

variable "max_ttl" {
  default     = 31536000
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
}
variable "forward_cookies" {
  type        = string
  default     = "none"
  description = "Time in seconds that browser can cache the response for S3 bucket"
}
variable "forward_header_values" {
  type        = list(string)
  description = "A list of whitelisted header values to forward to the origin"
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
}
variable "comment" {
  type        = string
  default     = "Managed by Terraform"
  description = "Comment for the origin access identity"
}
variable "origin_path" {
  # http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesOriginPath
  type        = string
  description = "An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path."
  default     = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM Certificate ARN"
  default     = ""
}
variable "logging_bucket" {
  description = "The bucket where do we store logs"
  type        = "map"
  default = {
    stage  = "devopsplant-logging.s3.amazonaws.com"
  }
}
variable "minimum_protocol_version" {
  type        = string
  description = "Cloudfront TLS minimum protocol version"
  default     = "TLSv1"
}
variable "allowed_methods" {
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront"
}
variable "compress" {
  type        = bool
  default     = false
  description = "Compress content for web requests that include Accept-Encoding: gzip in the request header"
}
variable "trusted_signers" {
  type        = list(string)
  default     = []
  description = "The AWS accounts, if any, that you want to allow to create signed URLs for private content. 'self' is acceptable."
}
variable "forward_query_string" {
  type        = bool
  default     = false
  description = "Forward query strings to the origin that is associated with this cache behavior"
}
variable "viewer_protocol_policy" {
  type        = string
  description = "allow-all, redirect-to-https"
  default     = "redirect-to-https"
}

variable "geo_restriction_type" {
  # e.g. "whitelist"
  default     = "none"
  description = "Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`"
  type        = string
}

variable "geo_restriction_locations" {
  type = list(string)

  # e.g. ["US", "CA", "GB", "DE"]
  default     = []
  description = "List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist)"
}
####### S3 settings ######
variable "origin_bucket" {
  type        = string
  default     = ""
  description = "Origin S3 bucket name"
}
variable "origin_force_destroy" {
  type        = bool
  default     = false
  description = "Delete all objects from the bucket  so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}
variable "cors_allowed_headers" {
  type        = list(string)
  default     = ["*"]
  description = "List of allowed headers for S3 bucket"
}
variable "cors_expose_headers" {
  type        = list(string)
  default     = ["ETag"]
  description = "List of expose header in the response for S3 bucket"
}
variable "cors_allowed_origins" {
  type        = list(string)
  default     = []
  description = "List of allowed origins (e.g. example.com, test.com) for S3 bucket"
}

variable "cors_max_age_seconds" {
  default     = 3600
  description = "Time in seconds that browser can cache the response for S3 bucket"
}

variable "static_s3_bucket" {
  type    = string
  default = "aws-cli"

  description = <<DOC
aws-cli is a bucket owned by amazon that will perminantly exist.
It allows for the data source to be called during the destruction process without failing.
It doesn't get used for anything else, this is a safe workaround for handling the fact that
if a data source like the one `aws_s3_bucket.selected` gets an error, you can't continue the terraform process
which also includes the 'destroy' command, where is doesn't even need this data source!
Don't change this bucket name, it's a variable so that we can provide this description.
And this works around a problem that is an edge case.
DOC
}
variable "bucket_domain_format" {
  type        = string
  default     = "%s.s3.amazonaws.com"
  description = "Format of bucket domain name"
}
variable "use_regional_s3_endpoint" {
  type        = bool
  description = "When set to 'true' the s3 origin_bucket will use the regional endpoint address instead of the global endpoint address"
  default     = false
}

####### Destribution Label  ######
variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev'"
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. `app` or `jenkins`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "convert_case" {
  type        = bool
  default     = true
  description = "Convert fields to lower case"
}
###### Route 53 #########
variable "parent_zone_id" {

}
variable "parent_zone_name" {
  type        = string
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}
variable "evaluate_target_health" {
  type        = bool
  default     = false
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries"
}