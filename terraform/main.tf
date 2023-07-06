resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "centos" {
  family = var.image_name
}
resource "yandex_compute_instance" "vm-nexus" {
  name        = local.name_vm1
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_resources.core
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_premtible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "centos:${var.metadata.ssh-keys}"
  }

}



