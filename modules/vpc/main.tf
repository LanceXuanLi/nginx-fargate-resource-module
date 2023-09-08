data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  available_azs = slice(data.aws_availability_zones.azs.names, 0, var.first-n-azs)
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = {
    Name = var.vpc-name
    Env  = var.vpc-env
  }
}

# --------------------- subnets ---------------------

// Used for the alb and nat gateways
resource "aws_subnet" "public" {
  count                   = length(local.available_azs)
  availability_zone       = local.available_azs[count.index]
  cidr_block              = "10.0.${count.index + 1}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags                    = {
    Name = "${var.vpc-name}-public-subnet-${count.index}"
    Env  = var.vpc-env
  }
}

// Used for the ecs tasks
resource "aws_subnet" "private" {
  count             = length(local.available_azs)
  availability_zone = local.available_azs[count.index]
  cidr_block        = "10.0.${count.index + 4}.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags              = {
    Name = "${var.vpc-name}-private-subnet-${count.index}"
    Env  = var.vpc-env
  }
}

# --------------------- gateways ---------------------

// Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.vpc-name}-igw"
    Env  = var.vpc-env
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags   = {
    Name = "${var.vpc-name}-eip"
    Env  = var.vpc-env
  }
}

/* Outbound gateway for private subnet
 * Each zone has its own nat gateway can get high-availability and reduce data transfer charges, it will be better
 * https://repost.aws/knowledge-center/vpc-reduce-nat-gateway-transfer-costs
 * but we need set unique eip for each nat gateway, eip is precious in aws, so I use one nat-gateway in this project.
 */
resource "aws_nat_gateway" "ngw" {

  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.eip.allocation_id
  subnet_id     = aws_subnet.public.0.id
  tags          = {
    Name = "${var.vpc-name}-nat"
    Env  = var.vpc-env
  }
}

# --------------------- route-tables ---------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc-name}-route-table-igw"
    Env  = var.vpc-env
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.vpc-name}-route-table-ngw"
    Env  = var.vpc-env
  }
}


resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# --------------------- secure-groups ---------------------

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.vpc-name}-sg-alb"
    Env  = var.vpc-env
  }
}

resource "aws_security_group" "ecs" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.vpc-name}-sg-ecs"
    Env  = var.vpc-env
  }
}

# --------------------- secure-groups-rules ---------------------


resource "aws_security_group_rule" "alb_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  to_port           = 80
  cidr_blocks       = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "alb_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  to_port           = 443
  cidr_blocks       = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "ecs" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  to_port                  = 80
  source_security_group_id = aws_security_group.alb.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "egress_alb" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs-egress" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}


