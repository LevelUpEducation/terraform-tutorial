provider "aws" {
  access_key = "AKIAJZD2X5IEZ3AMGR6A"
  secret_key = "Dnq9kWLg6aLZGSKBWRda8Iv66yEcwgFj+UxTQ5Un"
  region     = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
