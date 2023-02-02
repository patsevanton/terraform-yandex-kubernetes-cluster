# SA twoingress-k8s-cluster
resource "yandex_iam_service_account" "twoingress-k8s-cluster" {
  folder_id = var.folder_id
  name      = "twoingress-k8s-cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "twoingress-k8s-cluster-agent-permissions" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.twoingress-k8s-cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "twoingress-vpc-publicAdmin-permissions" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.twoingress-k8s-cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "twoingress-load-balancer-admin-permissions" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.twoingress-k8s-cluster.id}"
}

# SA k8s-node-group
resource "yandex_iam_service_account" "twoingress-k8s-node-group" {
  folder_id = var.folder_id
  name      = "twoingress-k8s-node-group"
}

resource "yandex_resourcemanager_folder_iam_member" "twoingress-k8s-node-group-permissions" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.twoingress-k8s-node-group.id}"
}

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