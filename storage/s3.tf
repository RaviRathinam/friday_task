
variable "product" {}

variable "application_tag" {}

variable "versioning" {}

variable "log_intervel" {}

locals {
  deployment = lower("${var.product}-${terraform.workspace}-${var.log_intervel}")
  env        = terraform.workspace
}

variable "lifecycle_rules" {
  type = map(object({
    prefix = string
    days   = number
    storageclass = string
    storageclass_2 = string
    expiration_days = number
  }))
  default = {
    "config" = {
      prefix = "config/"
      days   = 30
      storageclass = "STANDARD_IA"
      storageclass_2 = "GLACIER"
      expiration_days = 90
    }
    "log" = {
      prefix = "log/"
      days   = 30
      storageclass = "INTELLIGENT_TIERING"
      storageclass_2 = "GLACIER"
      expiration_days = 90
    }
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket = local.deployment
  acl    = "private"
  tags = {
    Application = var.application_tag,
    Environment = local.env
  }
  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      enabled = true
      prefix  = lifecycle_rule.value.prefix


      noncurrent_version_transition {
        days          = lifecycle_rule.value.days
        storage_class = lifecycle_rule.value.storageclass
      }

      noncurrent_version_transition {
        days          = lifecycle_rule.value.days
        storage_class = lifecycle_rule.value.storageclass_2
      }

      noncurrent_version_expiration {
        days = 90
      }
    }
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}
