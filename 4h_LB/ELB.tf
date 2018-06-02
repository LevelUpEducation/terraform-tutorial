provider "aws" {
  region = "eu-west-1"
}

variable "number_of_instances" {
  description = "Number of instances to create and attach to ELB"
  default     = 1
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

######
# ELB
######
module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "elb-example"

  subnets         = ["${data.aws_subnet_ids.all.ids}"]
  security_groups = ["${data.aws_security_group.default.id}"]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8080"
      instance_protocol = "HTTP"
      lb_port           = "8080"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  // Uncomment this section and set correct bucket name to enable access logging
  //  access_logs = [
  //    {
  //      bucket = "my-access-logs-bucket"
  //    },
  //  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  # ELB attachments
  number_of_instances = "${var.number_of_instances}"
  instances           = ["${module.ec2_instances.id}"]
}

################
# EC2 instances
################
module "ec2_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = "${var.number_of_instances}"

  name                        = "my-app"
  ami                         = "ami-ebd02392"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${data.aws_security_group.default.id}"]
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  associate_public_ip_address = true
}

resource "aws_lb_target_group_attachment" "front_end" {
  target_group_arn = "${aws_lb_target_group.front_end.arn}"
  target_id        = "${element(module.ec2_instances.id, 0)}"
  port             = 80
}

resource "aws_lb_target_group" "front_end" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.default.id}"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.front_end.arn}"
    type             = "forward"
  }
}

resource "aws_lb" "front_end" {
  name               = "front-end-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_group.default.id}"]

  subnets = ["${data.aws_subnet_ids.all.ids}"]

  enable_deletion_protection = false

  tags {
    Environment = "production"
  }
}
