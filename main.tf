terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "net" {
  description = "Виртуальная сеть кампании"
  count = 1
  name = "Private_VPC"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "sa_for_app" {
  folder_id = var.folder_id
  name      = "s3-sa"
}

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_vpc_subnet" "private_vpc" {
  name = "VPC_APP"
  description = "VPC для изоляции приложения"
  network_id     = yandex_vpc_network.net[0].id
  v4_cidr_blocks = [var.app_cidr]
  zone           = var.zone
}

resource "yandex_resourcemanager_folder_iam_binding" "sa_puller_role" {
  folder_id = var.folder_id
  members = [
    "serviceAccount:${yandex_iam_service_account.sa_for_app.id}",
  ]
  role  = "container-registry.images.puller"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa_for_app.id}"
}

resource "yandex_compute_instance" "app" {
  name        = "optimized"
  zone        = var.zone

  service_account_id = yandex_iam_service_account.sa_for_app.id

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc.id
    nat = true
  }
  resources {
    cores = 2
    memory = 2
  }

  metadata = {
     docker-container-declaration = file("${path.module}/app/declaration.yaml")
     user-data = file("${path.module}/app/cloud_config.yaml")
  }
}


module "static" {
  source      = "./modules/static"
  folder_id   = var.folder_id
  bucket_name = var.public_s3_name
  s3scc_id    = yandex_iam_service_account.sa_for_app.id
  backend_endpoint = "${yandex_compute_instance.app.network_interface.0.nat_ip_address}:8000"
}


output "creator-site" {
  value = "Сайт: http://website.yandexcloud.net/${var.public_s3_name}/app.html"
}

output "external_ip" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}