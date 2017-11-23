variable "aws_region" {
  default = "eu-west-1"
}

variable "bastion_sg_allow" {}

variable "env" {}

variable "short_region" {
  default = {
    ap-northeast-1 = "ap-no1"
    ap-northeast-2 = "ap-no2"
    ap-southeast-1 = "ap-so1"
    ap-southeast-2 = "ap-so2"
    eu-central-1   = "eu-ce1"
    eu-west-1      = "eu-we1"
    sa-east-1      = "sa-ea1"
    us-east-1      = "us-ea1"
    us-west-1      = "us-we1"
    us-west-2      = "us-we2"
  }
}

variable "zones" {
  type = "list"
  default = []
}

variable "keypair_name" {
  default = "cycloid"
}

variable "private_subnets_ids" {
  type = "list"
  default = [""]
}

variable "public_subnets_ids" {
    type = "list"
}

# variable "private_zone_id" {}

variable "cache_subnet" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "project" {
  default = "magento"
}

variable "rds_database" {
  default = "magento"
}

variable "rds_disk_size" {
  default = 10
}

variable "rds_multiaz" {
  default = true
}

variable "rds_password" {
  default = "ChangeMePls"
}

variable "rds_type" {
  default = "db.t2.small"
}

variable "rds_username" {
  default = "magento"
}

variable "rds_engine" {
  default = "mysql"
}

variable "rds_engine_version" {
  default = "5.7.16"
}

variable "rds_backup_retention" {
  default = 7
}

variable "rds_parameters" {
  default = ""
}

variable "rds_subnet" {
  default = ""
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_skip_final_snapshot" {
  default = false
}

###

# front

###

variable "magento_ssl_cert" {}

variable "front_disk_size" {
  default = 60
}

variable "front_disk_type" {
  default = "gp2"
}

variable "front_type" {
  default = "t2.small"
}

variable "front_ebs_optimized" {
  default = false
}

variable "front_count" {
  default = 1
}

###

# ElastiCache

###

variable "elasticache_type" {
  default = "cache.t2.micro"
}

variable "elasticache_nodes" {
  default = 1
}

variable "elasticache_engine" {
  default = "redis"
}

variable "elasticache_parameter_group_name" {
  default = "default.redis3.2"
}

variable "elasticache_port" {
  default = "6379"
}
