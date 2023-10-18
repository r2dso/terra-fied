# data "local_file" "public_ip" {
#   depends_on = [null_resource.fetch_public_ip]
#   filename = "${path.module}/public_ip.json"
# }

data "http" "public_ip_data" {
  url = "https://ifconfig.io/ip"
}