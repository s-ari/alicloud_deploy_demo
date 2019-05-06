variable "prefix" {
  default = "demo"
}

variable "auth" {
  type = "map"

  default = {
    access_key = ""
    secret_key = ""
    region     = "ap-northeast-1"
  }
}

variable "vpc" {
  type = "map"

  default = {
    name       = "vpc"
    cidr_block = "10.0.0.0/16"
  }
}

variable "vswitch_zone_a" {
  type = "map"

  default = {
    availability_zone = "ap-northeast-1a"
    cidr_block        = "10.0.1.0/24"
    name              = "vswitch_a"
  }
}

variable "ecs" {
  type = "map"

  default = {
    image_id                   = ""
    instance_type              = "ecs.t5-lc2m1.nano"
    count                      = "1"
    system_disk_size           = "40"
    password                   = "Demo12345"
    instance_name              = "ecs"
    internet_max_bandwidth_out = "1"
  }
}

variable "sg" {
  type = "map"

  default = {
    name = "sg"
  }
}

variable "slb" {
  type = "map"

  default = {
    name = "slb"
  }
}
