resource "yandex_iam_service_account" "k8s" {
  name        = "k8s-${var.cluster_name}"
  description = "service account for kubernetes"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-cluster-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-user" {
  folder_id = var.folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-publicAdmin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_kubernetes_cluster" "zonal_cluster_resource_name" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-cluster-agent,
    yandex_resourcemanager_folder_iam_member.load-balancer-admin,
    yandex_resourcemanager_folder_iam_member.vpc-publicAdmin,
    y
  ]
  folder_id                = var.folder_id
  name                     = var.cluster_name
  description              = var.cluster_name
  cluster_ipv4_range       = var.cluster_ipv4_range
  service_ipv4_range       = var.service_ipv4_range
  network_id               = var.network_id
  node_ipv4_cidr_mask_size = var.node_ipv4_cidr_mask_size

  dynamic "network_implementation" {
    for_each = var.cilium ? [1] : []
    content {
      cilium {}
    }
  }

  master {
    dynamic "regional" {
      for_each = var.cluster_type == "regional" ? [0] : []
      content {
        region = "ru-central1"
        location {
          zone      = "ru-central1-a"
          subnet_id = var.zone_a_subnet_id
        }
        location {
          zone      = "ru-central1-b"
          subnet_id = var.zone_b_subnet_id
        }
        location {
          zone      = "ru-central1-c"
          subnet_id = var.zone_c_subnet_id
        }
      }
    }
    dynamic "zonal" {
      for_each = var.cluster_type == "zonal" ? [0] : []
      content {
        zone      = var.zone
        subnet_id = var.subnet_id
      }
    }
    version            = var.version_k8s
    public_ip          = var.public_ip
    security_group_ids = var.security_group_ids

    maintenance_policy {
      auto_upgrade = var.auto_upgrade_enable

      maintenance_window {
        start_time = var.maintenance_window_start_time
        duration   = var.maintenance_window_duration
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8s.id

  labels = {
    env = var.cluster_name
  }

  release_channel         = var.release_channel
  network_policy_provider = var.cilium ? null : "CALICO"

}