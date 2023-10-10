variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}
variable "remoteexec_enabled" {
    type = bool
    default = false
}

variable "weak_enabled" {
    type = bool
    default = false
}