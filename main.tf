resource "yandex_kubernetes_cluster" "regional_cluster_resource_name" {
  name        = "name"
  description = "description"

  network_id = var.network_id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "${yandex_vpc_subnet.subnet_a_resource_name.zone}"
        subnet_id = "${yandex_vpc_subnet.subnet_a_resource_name.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.subnet_b_resource_name.zone}"
        subnet_id = "${yandex_vpc_subnet.subnet_b_resource_name.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.subnet_c_resource_name.zone}"
        subnet_id = "${yandex_vpc_subnet.subnet_c_resource_name.id}"
      }
    }

    version   = var.version
    public_ip = var.public_ip_enable

    maintenance_policy {
      auto_upgrade = var.auto_upgrade_enable

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }

    master_logging {
      enabled = true
      folder_id = var.folder_id
      kube_apiserver_enabled = var.kube_apiserver_enabled
      cluster_autoscaler_enabled = var.cluster_autoscaler_enabled
      events_enabled = var.events_enabled
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id

  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  release_channel = var.release_channel
}