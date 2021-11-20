# AWS S3 bucket Terraform module
### Problem Statement 1
Consider an application which is used to store weather reports on S3. This application
needs 3 different S3 buckets for storing hourly, daily and weekly reports.
Your task is to automate the S3 bucket creation with terraform.

Terraform module which creates S3 bucket on AWS with features provided by Terraform AWS provider. 

#### Notes:
- AWS named profiles are used to create the aws resoures(s3 bucket). So you need to configure aws [named profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) before applying terraform changes. - This is to avoid using secret keys in the code 
- Dynamic blocks are used to create lifecycle_rules in s3 bucket.

### lifecycle_rule example
you need to add the required values to create a new rule in lifecycle_rules variable.  


```hcl
    "log" = {
      prefix = "log/"
      days   = 30
      storageclass = "INTELLIGENT_TIERING"
      storageclass_2 = "GLACIER"
      expiration_days = 90
    }
```
## Inputs

| Name | Description | Type | Options | Required |
|------|-------------|------|---------|:--------:|
| log Intervel | (Required) The time intervel for storing log the reports  | `string` | `Hourly, Daily, Weekly` | yes |
| Profile | (Required) The name of the aws profile | `string` | `Null` | yes |
| versioning_enabled | (Required)  Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `false, true` | yes |
