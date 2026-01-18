# Домашнее задание: Организация сети (Yandex Cloud + Terraform)

## Описание

В рамках задания была создана инфраструктура в Yandex Cloud с использованием Terraform.

Реализована схема:
- Одна VPC
- Публичная подсеть с NAT-инстансом и VM с публичным IP
- Приватная подсеть с VM без публичного IP
- Выход в интернет из private subnet осуществляется через NAT instance
- Подключение к private VM выполняется через public VM (jump host)

---

## Созданные ресурсы

### VPC
- Network: `clo01-vpc`

### Подсети
- Public subnet:
  - name: `public`
  - CIDR: `192.168.10.0/24`
- Private subnet:
  - name: `private`
  - CIDR: `192.168.20.0/24`

### NAT instance
- Размещён в public subnet
- Внутренний IP: `192.168.10.254`
- Image ID: `fd80mrhj8fl2oe87o4e1`
- Используется как шлюз для private subnet

### Route table
Для private subnet настроен маршрут:
- `0.0.0.0/0` → `192.168.10.254`

### Виртуальные машины
- Public VM:
  - Находится в public subnet
  - Имеет публичный IP
  - Используется для подключения к private VM
- Private VM:
  - Находится в private subnet
  - Не имеет публичного IP
  - Выходит в интернет через NAT instance

### Security Group
Разрешены:
- SSH (22) с любого IP
- ICMP (ping)
- Любой трафик из подсети `192.168.20.0/24` (для корректной работы NAT)

---


