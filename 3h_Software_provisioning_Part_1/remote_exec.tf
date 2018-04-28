provider "aws" {
  region = "us-east-1"
}

variable "us-east-zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "pvt_key" {}

variable "key_name" {
  default = "my-key-name"
}

variable "sg-id" {
  default = "sg-xxxxxxxxx"
}

resource "aws_instance" "frontend" {
  availability_zone = "${var.us-east-zones[count.index]}"
  ami               = "ami-66506c1c"
  instance_type     = "t2.micro"
  key_name          = "${var.key_name}"
  security_groups   = "${sg-id}"

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      # install nginx
      "sudo apt-get update",

      "sudo apt-get -y install nginx",
    ]
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "/var/www/html/index.html"
  }
}
