data "aws_region" "current" {
}
data "aws_subnet" "public_a" {
  tags = {
    "Name" = "tdc-dev-public-1a"
  }
}
data "aws_subnet" "public_b" {
  tags = {
    "Name" = "tdc-dev-public-1b"
  }
}
data "aws_subnet" "private_a" {
  tags = {
    "Name" = "tdc-dev-private-1a"
  }
}
data "aws_subnet" "private_b" {
  tags = {
    "Name" = "tdc-dev-private-1b"
  }
}
