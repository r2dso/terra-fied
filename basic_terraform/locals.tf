locals {
  public_ip_data = jsondecode(data.local_file.public_ip.content)
}