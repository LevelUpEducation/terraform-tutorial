provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "this" {}

resource "aws_instance" "backend" {
  count                  = "${var.number_instances}"
  availability_zone      = "${data.aws_availability_zones.this.names[count.index]}"
  ami                    = "ami-66506c1c"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    # The connection will use the local SSH agent for authentication
    inline = ["echo Successfully connected"]

    connection {
      user        = "ubuntu"
      type        = "ssh"
      private_key = "${file(var.pvt_key)}"
    }
  }
}

#resource "null_resource" "ansible-pre-tasks" {
#  provisioner "local-exec" {
#    command = "ansible-playbook -e ssh-key=${var.pvt_key} -i '${aws_instance.backend.public_ip},' ./ansible/pre-task.yml -v"
#  }
#
#  depends_on = ["aws_instance.backend"]
#}

resource "null_resource" "ansible-main" {
  provisioner "local-exec" {
    command = "ansible-playbook -e sshKey=${var.pvt_key} -i '${aws_instance.backend.public_ip},' ./ansible/setup-backend.yaml -v"
  }

  depends_on = ["aws_instance.backend"]
}
