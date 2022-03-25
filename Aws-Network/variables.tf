variable "region" {
  type    = string 
  default = "us-east-2"
}

variable "myvpc" {
  default = "10.0.0.0/16"
}
variable "PrivateSubnet1CIDR" {
  default = "10.0.1.0/24"
}
variable "PubliceSubnet1CIDR" {
  default = "10.0.2.0/24"
}
variable "PrivateSubnet2CIDR" {
  default = "10.0.3.0/24"
}
variable "PubliceSubnet2CIDR" {
  default = "10.0.4.0/24"
}