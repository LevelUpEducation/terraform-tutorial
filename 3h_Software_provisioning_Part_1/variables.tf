variable "key_name" {
  default = "stefan-personal-aws"
}

variable "pvt_key" {
  default = "/home/stefan/.ssh/stefan-personal-aws.pem"
}

variable "us-east-zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg-id" {
  default = "sg-4e1b7b39"
}
