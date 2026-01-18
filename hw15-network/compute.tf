

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# NAT instance (по заданию)
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  zone        = var.zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 10
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
    ip_address = "192.168.10.254"
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    "ssh-keys" = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}

# VM в public subnet с публичным IP
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  zone        = var.zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    "ssh-keys" = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}

# VM в private subnet без публичного IP
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  zone        = var.zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    "ssh-keys" = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
