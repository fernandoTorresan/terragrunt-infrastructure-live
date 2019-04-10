# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an S3 bucket
  remote_state {
    backend = "s3"

    config {
      encrypt        = true
      bucket         = "<bucket_name>"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "<table_name>"
    }
  }

  iam_role = "arn:aws:iam::<aws_account_id>:role/<role_name>"

  # Configure root level variables that all resources can inherit
  terraform {
    extra_arguments "bucket" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      optional_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("account.tfvars", "ignore")}",
        "${get_tfvars_dir()}/${find_in_parent_folders("region.tfvars", "ignore")}",
        "${get_tfvars_dir()}/${find_in_parent_folders("environment.tfvars", "ignore")}",
      ]

      extra_arguments "retry_lock" {
        commands = ["${get_terraform_commands_that_need_locking()}"]

        arguments = [
          "-lock-timeout=20m",
        ]
      }
    }
  }
}
