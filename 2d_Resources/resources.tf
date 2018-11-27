provider "aws" {
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "frontend" {
  depends_on    = ["aws_instance.backend"]
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend" {
  count         = 2
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  timeouts {
    create = "60m"
    delete = "2h"
  }
}
