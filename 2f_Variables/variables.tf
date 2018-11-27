provider "aws" {
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "Dnq9kWLg6aLZGSKBWRda8Iv66yEcwgFj+UxTQ5Un"
  region     = "us-east-1"
}

variable "zones" {
  default = ["us-east-1a", "us-east-1b"]
}

resource "aws_instance" "example" {
  count                 = 2
  availability_zone     = "${var.zones[count.index]}"
  ami                   = "ami-07585467"
  instance_type         = "t2.micro"
}
