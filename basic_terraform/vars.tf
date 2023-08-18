variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}
variable "remoteexec-enabled" {
    type = bool
    default = true
}
