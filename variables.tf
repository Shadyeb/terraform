variable "region" {
  type    = string 
  default = "us-east-2"
}

variable "ami" {
  type    = string 
  default = "ami-0fb653ca2d3203ac1"
}

variable "public_key" {
  description = "ssh public key"
}