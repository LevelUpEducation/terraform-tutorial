provider "aws" {
  access_key = "AKIAIL44XZJTUA5Y2Q6A"
  secret_key = "zWbd6mhG6TguTD98EwZM3Ds4Vx7epgkSsJph9qj1"
  region     = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
