variable "folder_id" {
  description = "The ID of the folder that the resource belongs to. If it is not provided, the default provider folder is used."
  type        = string
}

variable "service_account_id" {
  description = "ID of the service account authorized for this instance."
  type        = string
}

variable "network_id" {
  type = string
}

variable "version" {
  type = string
}
variable "public_ip_enable" {
  type = bool
}
variable "auto_upgrade_enable" {
  type = bool
}
variable "kube_apiserver_enabled" {
  type = bool
}
variable "cluster_autoscaler_enabled" {
  type = bool
}
variable "events_enabled" {
  type = bool
}
variable "node_service_account_id" {
  type = string
}
variable "release_channel" {
  type = string
}