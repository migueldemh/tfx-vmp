variable "tf_hostname" {
  description = "Hostname of the Terraform instance."
  type = string
  default = "app.terraform.io"
}

variable "TFx_org_token" {
  description = "Terraform API Token."
  type = string
  default = "none"
}

variable "tf_organization" {
  description = "Name of the TF Organization"
  type = string
  default = "<ADD-ORG-NAME-FROM-TFC>"
}

variable "tf_workspaces" {
  description = "Set of TF Workspace Names"
  type = set(string)
  default = ["workspaceA",
    "workspaceB", "workspaceC"]
}
