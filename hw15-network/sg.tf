resource "yandex_vpc_security_group" "sg" {
  name       = "clo01-ssh-allow"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "Ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "ANY"
    description    = "Allow all from private subnet to NAT"
    v4_cidr_blocks = ["192.168.20.0/24"]
  }
}
