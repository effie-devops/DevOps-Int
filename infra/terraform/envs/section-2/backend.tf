# Local backend for section-2. Swap to the S3 backend below if you have
# a remote state bucket provisioned.
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket       = "django-api-remote-state-bucket-001"
#     key          = "section-2/terraform.tfstate"
#     region       = "us-east-1"
#     encrypt      = true
#     use_lockfile = true
#     profile      = "djangoapi-uat"
#   }
# }
