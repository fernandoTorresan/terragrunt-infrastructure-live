# ---------------------------------------------------------------------------------------------------------------------
# Tabela DynamoDB - USER
#
# Tabela responsável ...
# ---------------------------------------------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
  # working directory, into a temporary folder, and execute your Terraform commands in that folder.
  terraform {
    source = "git::ssh://git@github.com/fernandoTorresan/terraform-infrastructure-modules.git//dynamodb/simple?ref=0.1.0"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

table_name = "USER"

hash_key = "cpf"

range_key = "id"

dynamodb_attributes = [
  {
    name = "cpf"
    type = "S"
  },
  {
    name = "id"
    type = "S"
  },
]

read_capacity = 1

write_capacity = 1

tags = {
  ManagedBy = "Terraform"
}
