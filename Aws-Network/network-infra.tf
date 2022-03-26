#Creating first VPC via Terraform
resource "aws_vpc" "myvpc" {
  cidr_block = var.myvpc
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

resource "aws_internet_gateway" "myigw" {
  tags = {
    Name = "myigw"
  }
}

resource "aws_internet_gateway_attachment" "igw-attach" {
  internet_gateway_id = aws_internet_gateway.myigw.id
  vpc_id              = aws_vpc.myvpc.id
}

resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.PubliceSubnet1CIDR
  availability_zone = "us-east-2b"
  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "priv1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.PrivateSubnet1CIDR
  availability_zone = "us-east-2b"
  tags = {
    Name = "priv-sub-1"
  }
}

resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.PubliceSubnet2CIDR
  availability_zone = "us-east-2a"
  tags = {
    Name = "pub-sub-2"
  }
}

resource "aws_subnet" "priv2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.PrivateSubnet2CIDR
  availability_zone = "us-east-2a"
  tags = {
    Name = "priv-sub-2"
  }
}

resource "aws_eip" "ngwib1" {
  vpc      = true
  depends_on = [
    aws_internet_gateway_attachment.igw-attach
  ]
  tags = {
    Name = "Nat-Gateway-EIB-1"
  }
}
resource "aws_eip" "ngwib2" {
  vpc      = true
  depends_on = [
    aws_internet_gateway_attachment.igw-attach
  ]
  tags = {
    Name = "Nat-Gateway-EIB-2"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.ngwib1.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name = "gw NAT1"
  }

}
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.ngwib2.id
  subnet_id     = aws_subnet.pub2.id

  tags = {
    Name = "gw NAT2"
  }

}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Public Route Table"
  }
}

  resource "aws_default_route_table" "drt" {
  depends_on = [
    aws_internet_gateway_attachment.igw-attach
  ]
  default_route_table_id = aws_route_table.pubrt.id
 route = [ {
   cidr_block = "0.0.0.0/0"
   destination_prefix_list_id = null
   egress_only_gateway_id = null
   gateway_id = aws_internet_gateway.myigw.id
   instance_id = null
   ipv6_cidr_block = null
   network_interface_id = null
   transit_gateway_id = null
   vpc_endpoint_id = null
   vpc_peering_connection_id = null
   nat_gateway_id = null

 } ]

 
  tags = {
    Name = "DefaultPublicRoute"
  }
}

resource "aws_route_table_association" "pub-sub-1-rt" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "pub-sub-2-rt" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.pubrt.id
}



#privites

resource "aws_route_table" "priv-rt-1" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "privte Route Table1"
  }
}

  resource "aws_default_route_table" "dpr1" {
  default_route_table_id = aws_route_table.priv-rt-1.id
 route = [ {
   cidr_block = "0.0.0.0/0"
   destination_prefix_list_id = null
   egress_only_gateway_id = null
   gateway_id = null
   instance_id = null
   ipv6_cidr_block = null
   network_interface_id = null
   transit_gateway_id = null
   vpc_endpoint_id = null
   vpc_peering_connection_id = null
   nat_gateway_id = aws_nat_gateway.nat1.id

 } ]

 
  tags = {
    Name = "Default Privte RT 1 "
  }
}

resource "aws_route_table_association" "priv-sub-1-ascc" {
  route_table_id = aws_route_table.priv-rt-1.id
  subnet_id      = aws_subnet.priv1.id

}

resource "aws_route_table" "priv-rt-2" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "privte Route Table2"
  }
}
###
resource "aws_default_route_table" "dpr2" {
  default_route_table_id = aws_route_table.priv-rt-2.id
   route = [ {
   cidr_block = "0.0.0.0/0"
   destination_prefix_list_id = null
   egress_only_gateway_id = null
   gateway_id = null
   instance_id = null
   ipv6_cidr_block = null
   network_interface_id = null
   transit_gateway_id = null
   vpc_endpoint_id = null
   vpc_peering_connection_id = null
   nat_gateway_id = aws_nat_gateway.nat2.id

 } ]

 
  tags = {
    Name = "Default Privte RT 2 "
  }
}

resource "aws_route_table_association" "priv-sub-2-ascc" {
  route_table_id = aws_route_table.priv-rt-2.id
  subnet_id      = aws_subnet.priv2.id
}