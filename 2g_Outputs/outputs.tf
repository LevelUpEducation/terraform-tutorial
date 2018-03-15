provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
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
