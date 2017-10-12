output "elb_front_dns_name" {
  value = "${module.magento.elb_front_dns_name}"
}
output "elb_front_zone_id" {
  value = "${module.magento.elb_front_zone_id}"
}
output "front_private_ips" {
  value = "${module.magento.front_private_ips}"
}
output "cache_address" {
  value = "${module.magento.cache_address}"
}
output "rds_address" {
  value = "${module.magento.rds_address}"
}
output "rds_port" {
  value = "${module.magento.rds_port}"
}
output "rds_username" {
  value = "${module.magento.rds_username}"
}
output "rds_password" {
  value = "${var.rds_password}"
}
output "rds_database" {
  value = "${module.magento.rds_database}"
}
