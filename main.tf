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
  token    = var.TFx_org_token
}


resource "tfe_team" "test" {
  name = "test-team-name"
  organization = var.tf_organization
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


resource "tfe_team_member" "app-dev-app" {
  team_id  = tfe_team.app-dev-team.id
  username = "miguelheredero"
}


output "tf_workspace_ids" {
  value = { for k, v in tfe_workspace.test : k => v.id }
}