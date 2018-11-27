provider "aws" {
  alias      = "us-east-1"
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "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"
  region =     "us-east-1"
}

provider "aws" {
  alias      = "us-west-1"
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "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"
  region =     "us-west-1"
}

variable "us-east-zones" {
  default = ["us-east-1a","us-east-1b"]
}

variable "us-west-zones" {
  default = ["us-west-1a","us-west-1b"]
}

resource "aws_instance" "east_frontend" {
  provider          = "aws.us-east-1"
  count             = 2
  depends_on        = ["aws_instance.east_backend"]
  availability_zone = "${var.us-east-zones[count.index]}"
  ami               = "ami-66506c1c"
  instance_type     = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "west_frontend" {
  provider          = "aws.us-west-1"
  count             = 2
  depends_on        = ["aws_instance.west_backend"]
  availability_zone = "${var.us-west-zones[count.index]}"
  ami               = "ami-07585467"
  instance_type     = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "east_backend" {
  provider          = "aws.us-east-1"
  count             = 2
  availability_zone = "${var.us-east-zones[count.index]}"
  ami               = "ami-66506c1c"
  instance_type     = "t2.micro"

  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_instance" "west_backend" {
  provider          = "aws.us-west-1"
  count             = 2
  availability_zone = "${var.us-west-zones[count.index]}"
  ami               = "ami-07585467"
  instance_type     = "t2.micro"

  lifecycle {
    prevent_destroy = true
  }
}

output "frontend_east_ip" {
  value = "${aws_instance.east_frontend.*.public_ip}"
}
output "frontend_west_ip" {
  value = "${aws_instance.west_frontend.*.public_ip}"
}

output "backend_east_ips" {
  value = "${aws_instance.east_backend.*.public_ip}"
}
output "backend_west_ips" {
  value = "${aws_instance.west_backend.*.public_ip}"
}
