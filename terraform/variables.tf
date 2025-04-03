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

variable "subscription" {
  type        = string
  default     = "506212d5-fc69-4c5d-bafa-e69469fe4127"
}