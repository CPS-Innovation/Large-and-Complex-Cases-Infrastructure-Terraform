output "private_dns_zone_id" {
  value = {
    for k, v in private_dns_zone_ids.main :
    k => v.id
  }
}
