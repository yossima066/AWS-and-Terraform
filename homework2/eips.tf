resource "aws_eip" "nat1" {

  depends_on = [aws_internet_gateway.Whiskeyword]

  tags = {
    Name = "nat1 us-east-1a"
  }

}

resource "aws_eip" "nat2" {

  depends_on = [aws_internet_gateway.Whiskeyword]

  tags = {
    Name = "nat2 us-east-1b"
  }

}
