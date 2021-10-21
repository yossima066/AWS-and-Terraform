
resource "aws_internet_gateway" "Whiskeyword" {
  vpc_id = aws_vpc.Whiskeyword.id

  tags = {
    Name = "Whiskeyword"
  }


}
