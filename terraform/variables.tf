variable "environment" {
  type        = string
  default     = "dev"
}

variable "allowed_ports" {
  type        = list(number)
  default     = [80, 22]
}

variable "location" {
  type        = string
  default     = "West Europe"
}
