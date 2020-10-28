data "aws_region" "current" {
}
data "aws_caller_identity" "current" {
}
data "aws_subnet" "public_a" {
  tags = {
    "Name" = "exodus-vpc-public-us-west-2a"
  }
}
data "aws_subnet" "public_b" {
  tags = {
    "Name" = "exodus-vpc-public-us-west-2b"
  }
}
data "aws_subnet" "private_a" {
  tags = {
    "Name" = "exodus-vpc-private-us-west-2a"
  }
}
data "aws_subnet" "private_b" {
  tags = {
    "Name" = "exodus-vpc-private-us-west-2b"
  }
}
