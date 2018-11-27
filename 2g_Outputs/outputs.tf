provider "aws" {
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami                   = "ami-66506c1c"
  instance_type         = "t2.micro"
}

resource "aws_instance" "backend" {
  count                 = 2
  ami                   = "ami-66506c1c"
  instance_type         = "t2.micro"
}

output "frontend_ip" {
  value = "${aws_instance.frontend.public_ip}"
}

output "backend_ips" {
  value = "${aws_instance.backend.*.public_ip}"
}
