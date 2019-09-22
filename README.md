# terraform-cloudfront
Create Cloudfront distribution 

This solution will containes the following components:

* Create s3 Bucket matches the CF Name
* Tags for tracking
* CloudFront Distribution serve index.html from the S3 bucket created above.
* Logging all requests and store it in S3 bucket.
* Route53 Record 
* Module output to be used by other modules if exist.

The solution file should be like this
```
module "devopsplant-cloudfront-env" {
  source                   = "git::https://github.com/devopsplant/terraform-cloudfront.git?ref=tags/0.1"
  origin_bucket               = "devopsplant.com.au"
  acm_certificate_arn         = "certificate ARN"
  aliases                     = ["devopsplant.com.au","www.devopsplant.com"]
  stage                       = "staging"
  name                        = "website"
  parent_zone_name            = "devopsplant.com.au"

}
```