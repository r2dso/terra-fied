variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}
variable "remoteexec_enabled" {
    type = bool
    default = false
}

variable "weakinstance_enabled" {
    type = bool
    default = false
}

variable "priv_key" {
    description = "Private key for SSH access"
}