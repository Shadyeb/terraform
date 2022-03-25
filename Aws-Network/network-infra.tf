
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
################## From Here i will start tomorrow 
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_default_route_table" "mydefaultRT" {
depends_on = aws_internet_gateway_attachment.igw-attach.id

route = [ {
  cidr_block = aws_vpc.myvpc.id
  destination_prefix_list_id = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myigaw.id

} ]

  tags = {
    Name = "Default Route Table"
  }
}


