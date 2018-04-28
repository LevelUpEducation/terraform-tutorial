variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-66506c1c"
    us-west-1 = "ami-07585467"
  }
}

variable "region" {
  default="us-east-1"
}

variable "total_instances" {
  default=1
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
