provider "aws" {
  region = "eu-west-1"
}

#########################################
# IAM user, login profile and access key
#########################################
module "iam_user" {
  source = "../../modules/iam-user"

  name          = "vasya.pupkin"
  force_destroy = true

  password_reset_required = true
}

