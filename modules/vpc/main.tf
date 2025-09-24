resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "igw-${var.project_name}-${var.environment}" }
}

# Public subnets (across 2 AZs)
resource "aws_subnet" "public" {
  for_each = toset(slice(var.azs, 0, 2))
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(var.azs, each.value))
  availability_zone = each.value
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-${var.environment}-public-${each.value}" }
}

# Private subnets (across 2 AZs)
resource "aws_subnet" "private" {
  for_each = toset(slice(var.azs, 0, 2))
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10 + index(var.azs, each.value))
  availability_zone = each.value
  tags = { Name = "${var.project_name}-${var.environment}-private-${each.value}" }
}

# NAT Gateways & Elastic IPs (one per AZ)
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags = { Name = "nat-${each.key}" }
}

# Route tables (public)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route tables with NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_to_nat" {
  for_each = aws_nat_gateway.nat
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id
}
