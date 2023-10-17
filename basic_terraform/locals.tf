locals {
  public_ip_data = jsondecode(data.http.public_ip_data.body)
}