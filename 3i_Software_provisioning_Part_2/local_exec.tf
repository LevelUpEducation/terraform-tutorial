
provider "aws" {
  region     = "us-east-2"
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
  availability_zone     = "${var.us-east-zones[count.index]}"
  ami                   = "ami-66506c1c"
  instance_type         = "t2.micro"
  key_name              = "${var.key_name}"
  security_groups       = "${sg-id}"
  lifecycle {
    create_before_destroy = true
  }
  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    # The connection will use the local SSH agent for authentication
    inline = ["echo Successfully connected"]

    connection {
      user = "${local.vm_user}"
      user = "ubuntu"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook 
  }
}
