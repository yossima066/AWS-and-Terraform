resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.Whiskeyword.id

  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  availability_zone = "us-east-1a"

  tags = {
    Name = "public1 us-east-1a"
  }


}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.Whiskeyword.id

  cidr_block = "10.0.2.0/24"

  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public2 us-east-1b"
  }


}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.Whiskeyword.id

  cidr_block = "10.0.3.0/24"

  availability_zone = "us-east-1a"

  tags = {
    Name = "private1 us-east-1a"
  }


}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.Whiskeyword.id

  cidr_block = "10.0.4.0/24"

  availability_zone = "us-east-1b"

  tags = {
    Name = "private2 us-east-1b"
  }


}
