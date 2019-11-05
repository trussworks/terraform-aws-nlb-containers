variable "environment" {
  type = string
}

variable "nlb_name" {
  type = string
}

variable "logs_bucket" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_azs" {
  type = list(string)
}