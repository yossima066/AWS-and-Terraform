
resource "aws_route" "all_to_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Whiskeyword.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "private1_to_nat" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw1.id
  depends_on             = [aws_route_table.private1]
}

resource "aws_route" "private2_to_nat" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw2.id
  depends_on             = [aws_route_table.private2]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Whiskeyword.id


  tags = {
    Name = "public"
  }

}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.Whiskeyword.id



  tags = {
    Name = "private1"
  }

}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.Whiskeyword.id



  tags = {
    Name = "private2"

  }

}
