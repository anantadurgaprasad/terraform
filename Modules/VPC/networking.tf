data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  /*===========
  Create a local variable with cidrblock and availability zone for using in subnet creation
  =============*/
  public_subnets = {
    for idx, cidr_block in var.public_subnets : cidr_block => {
      cidr_block        = cidr_block
      availability_zone = data.aws_availability_zones.azs.names[idx % length(data.aws_availability_zones.azs.names)]
    }
  }
  private_subnets = {
    for idx, cidr_block in var.private_subnets : cidr_block => {
      cidr_block        = cidr_block
      availability_zone = data.aws_availability_zones.azs.names[idx % length(data.aws_availability_zones.azs.names)]
    }
  }
}

/*=============
Create VPC
===============*/
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_base
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-${var.app_name}-vpc"
  }

}


/*=============
Create Internet Gateway
===============*/
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  depends_on = [aws_vpc.main]
}





/*=============
Create Subnets
===============*/
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = local.public_subnets
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.availability_zone
  tags = tomap({
    "Name" = "${var.environment}-${var.app_name}-publicsubnet"
  })
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = local.private_subnets
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone
  tags = tomap({
    "Name" = "${var.environment}-${var.app_name}-privatesubnet"
  })
}


/*=============
Create ElasticIP and NAT Gateway
===============*/
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[var.public_subnets[0]].id
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

/*=============
Create Route Table
===============*/
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

/*======
Add Routes to Route Tables
=======*/
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


/* ======
 Route table associations
 ======= */


resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}


/*====
Security Groups
======*/

resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-${var.app_name}-db-sg-use1"
  description = "db-sg inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "TCP"
    security_groups = [aws_security_group.web_alb_sg.id]
  }




  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
    description = "MongoDB access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-${var.app_name}-db-sg-use1"
  }
}

resource "aws_security_group" "web_alb_sg" {
  name   = "${var.environment}-${var.app_name}-web-alb-sg-use1"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app_name}-web-alb-sg-use1"

  }
}


resource "aws_security_group" "web_sg" {
  name   = "${var.environment}-${var.app_name}-web-sg-use1"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.web_alb_sg.id]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    security_groups = [aws_security_group.web_alb_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app_name}-web-sg-use1"
  }
}


resource "aws_security_group" "jumphost_sg" {
  name        = "${var.environment}-${var.app_name}-jumphost-sg-use1"
  description = "jump host sg inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-${var.app_name}-jumphost-sg-use1"
  }
}




