provider "aws" {
  region = "us-east-1"
}

locals {
  default_name = "${join("-", list(terraform.workspace, "example"))}"
}

resource "aws_instance" "example" {
  tags = {
    Name = "${local.default_name}"
  }

  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
