# SET A TF WORKSPACE VARIABLE FOR "tf_token" with the TFC API Token
# https://www.terraform.io/docs/providers/tfe/index.html
# Configure the Terraform Enterprise Provider
terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.38.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}

provider "tfe" {
  hostname = var.tf_hostname
  token    = var.tf_token
}



resource "tfe_workspace" "test" {
  for_each = var.tf_workspaces
  name = each.key
  organization = var.tf_organization
}

output "tf_workspace_ids" {
  value = { for k, v in tfe_workspace.test : k => v.id }
}

resource "tfe_variable" "test" {
  for_each = { for k, v in tfe_workspace.test : k => v.id }
  key = "test_key_name"
  value = "test_value_name"
  category = "terraform"
  workspace_id = each.value
}

resource "tfe_team" "test" {
  name = "test-team-name"
  organization = var.tf_organization
}
