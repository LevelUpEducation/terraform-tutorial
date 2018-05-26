resource "aws_route53_zone" "primary" {
  name = "my-example.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.my-example.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.elb.this_elb_name}"]
}
