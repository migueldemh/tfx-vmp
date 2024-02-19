terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.38.0"
    }
    environment = {
      source  = "EppO/environment"
      version = "1.3.3"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}

provider "tfe" {
  hostname = var.tf_hostname
  token    = var.TFx_org_token
}

provider "tfe" {
  alias = "organization"
  token = var.TFx_org_token

}

data "environment_variables" "all" {
}
data "environment_variables" "atlas_slug" {
  filter = "^ATLAS_WORKSPACE_SLUG"
}


locals {
  list_organization_workspace = split("/", data.environment_variables.atlas_slug.items.ATLAS_WORKSPACE_SLUG)
  organization                = local.list_organization_workspace["0"]
  workspace                   = local.list_organization_workspace["1"]
}



resource "tfe_workspace" "test" {
  for_each = var.tf_workspaces
  name = each.key
  organization = var.tf_organization
}

resource "tfe_variable" "test" {
  for_each = { for k, v in tfe_workspace.test : k => v.id }
  key = "test_key_name"
  value = "test_value_name"
  category = "terraform"
  workspace_id = each.value
}

resource "tfe_team" "app-dev-team" {
  name = "app-dev-team"
  organization = var.tf_organization
}

resource "tfe_team" "app-dev-release-team" {
  name = "app-dev-release-team"
  organization = var.tf_organization
}

resource "tfe_team" "app-dev-admin-team" {
  name = "app-dev-admin-team"
  organization = var.tf_organization
}

resource "tfe_team_access" "app-dev" {
  for_each = { for k, v in tfe_workspace.test : k => v.id }
  access = "plan"
  team_id = tfe_team.app-dev-team.id
  workspace_id = each.value
}

resource "tfe_team_access" "app-dev-release" {
  for_each = { for k, v in tfe_workspace.test : k => v.id }
  access = "write"
  team_id = tfe_team.app-dev-release-team.id
  workspace_id = each.value
}

resource "tfe_team_access" "app-dev-admin" {
  for_each = { for k, v in tfe_workspace.test : k => v.id }
  access = "admin"
  team_id = tfe_team.app-dev-admin-team.id
  workspace_id = each.value
}



output "tf_workspace_ids" {
  value = { for k, v in tfe_workspace.test : k => v.id }
}