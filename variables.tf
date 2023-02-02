variable "zone" {
  type        = string
  default     = null
  description = "Zone of yandex cloud"
}

variable "cloud_id" {
  type    = string
  default = null
}

variable "folder_id" {
  type = string
}

variable "cluster_id" {
  type    = string
  default = null
}

variable "cilium" {
  type        = bool
  default     = false
  description = "Используем cilium для сети"
}
variable "service_account_id" {
  type    = string
  default = null
}

variable "node_service_account_id" {
  type    = string
  default = null
}

variable "version_k8s" {
  type    = string
  default = null
}

variable "k8s_name" {
  type    = string
  default = null
}

variable "ip_subnet" {
  type    = list(string)
  default = null
}

variable "network_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "cluster_ipv4_range" {
  type        = string
  default     = "10.1.0.0/16"

}

variable "service_ipv4_range" {
  type        = string
  default     = "10.2.0.0/16"
}

variable "vpc_folder_id" {
  type    = string
  default = ""
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
}

variable "public_ip" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type    = string
  default = "test"
}

variable "node_ipv4_cidr_mask_size" {
  type    = string
  default = "24"
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "List of attached security groups id"
}

variable "cluster_type" {
  type    = string
  default = "zonal"
}

variable "zone_a_subnet_id" {
  type    = string
  default = null
}

variable "zone_b_subnet_id" {
  type    = string
  default = null
}

variable "zone_c_subnet_id" {
  type    = string
  default = null
}