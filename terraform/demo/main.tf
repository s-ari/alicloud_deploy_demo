variable "access_key" {}
variable "secret_key" {}
variable "image_id" {}

# 認証情報
provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "ap-northeast-1"
}

# VPC 作成
resource "alicloud_vpc" "vpc" {
  name       = "${var.prefix}-${lookup(var.vpc, "name")}"
  cidr_block = "${lookup(var.vpc, "cidr_block")}"
}

# Vswitch 作成
resource "alicloud_vswitch" "vswitch_zone_a" {
  vpc_id            = "${alicloud_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vswitch_zone_a, "cidr_block")}"
  availability_zone = "${lookup(var.vswitch_zone_a, "availability_zone")}"
  name              = "${var.prefix}-${lookup(var.vswitch_zone_a, "name")}"
}

# ECS 作成
resource "alicloud_instance" "ecs" {
  count                      = "${lookup(var.ecs, "count")}"
  image_id                   = "${var.image_id}"
  instance_type              = "${lookup(var.ecs, "instance_type")}"
  system_disk_size           = "${lookup(var.ecs, "system_disk_size")}"
  security_groups            = ["${alicloud_security_group.sg.id}"]
  instance_name              = "${var.prefix}-${lookup(var.ecs, "instance_name")}${format("%02d", count.index + 1)}"
  host_name                  = "${var.prefix}-${lookup(var.ecs, "instance_name")}${format("%02d", count.index + 1)}"
  vswitch_id                 = "${alicloud_vswitch.vswitch_zone_a.id}"
  password                   = "${lookup(var.ecs, "password")}"
  internet_max_bandwidth_out = "${lookup(var.ecs, "internet_max_bandwidth_out")}"
}

# Security Group 作成
resource "alicloud_security_group" "sg" {
  name   = "${var.prefix}-${lookup(var.sg, "name")}"
  vpc_id = "${alicloud_vpc.vpc.id}"
}

# Security Group へSSHを許可 (デモ環境の為、全IPからの接続を許可しています)
resource "alicloud_security_group_rule" "sg_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  security_group_id = "${alicloud_security_group.sg.id}"
  cidr_ip           = "0.0.0.0/0"
}

# Security Group へHTTPを許可
resource "alicloud_security_group_rule" "sg_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  security_group_id = "${alicloud_security_group.sg.id}"
  cidr_ip           = "${lookup(var.vpc, "cidr_block")}"
}

# SLB 作成
resource "alicloud_slb" "classic" {
  name                 = "${var.prefix}-${lookup(var.slb, "name")}"
  internet             = true
  internet_charge_type = "paybytraffic"
  bandwidth            = 1
}

# SLB へECSを追加
resource "alicloud_slb_attachment" "slb_attach" {
  load_balancer_id = "${alicloud_slb.classic.id}"
  instance_ids     = ["${alicloud_instance.ecs.*.id}"]
}

# SLBで80を許可
resource "alicloud_slb_listener" "http" {
  load_balancer_id          = "${alicloud_slb.classic.id}"
  backend_port              = 80
  frontend_port             = 80
  bandwidth                 = 10
  protocol                  = "http"
  health_check              = "on"
  health_check_connect_port = "80"
  health_check_type         = "http"
  health_check_uri          = "/"
}
