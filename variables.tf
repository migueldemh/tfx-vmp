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
  default = "migueldemh"
}

variable "tf_workspaces" {
  description = "Set of TF Workspace Names"
  type = set(string)
  default = ["workspaceA",
    "workspaceB", "workspaceC"]
}
variable "agent_pool_set" {
  default     = false
  type        = bool
  description = "(Optional Bool) Flag to control of agent pool"
}