resource "aws_eip" "nat_gateway" {
  vpc = true
}

# Nat gate way for private subnet 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public-1-subnet.id

  tags = {
    Name = "NAT gw"
  }
}


# Private Route table 
resource "aws_route_table" "private_rtb" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id 
    }
    tags = {
        Name = "Private route table"
    }
}


# Private route table associatiom
resource "aws_route_table_association" "pritavte1" {
    subnet_id = aws_subnet.private-subnet.id
    route_table_id = aws_route_table.private_rtb.id
}

