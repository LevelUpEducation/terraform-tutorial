output "ips" {
  value = "${aws_instance.instance.*.public_ip}"
}
