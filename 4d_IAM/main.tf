provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user" {
  name          = "stefan-tf-demo"
  path          = "${var.path}"
  force_destroy = "${var.force_destroy}"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    "${aws_iam_user.user.name}",
  ]

  group = "${aws_iam_group.group.name}"
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

resource "aws_iam_group_policy" "policy" {
  name  = "policy"
  group = "${aws_iam_group.group.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#resource "aws_iam_group_policy_attachment" "test-attach" {
#  group      = "${aws_iam_group.group.name}"
#  policy_arn = "${aws_iam_group_policy.policy.arn}"
#}

