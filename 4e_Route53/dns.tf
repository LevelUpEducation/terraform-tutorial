provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "my-example.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.my-example.com"
  type    = "A"
  ttl     = "300"
  records = ["198.40.6.7"]
}
