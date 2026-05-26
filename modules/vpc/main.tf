# =============================================================================
# vpc
# =============================================================================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # dns support, always useful and good to have enabled 
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-main-VPC"
    }
  )
}

# =============================================================================
# internet gateway
# =============================================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-main-igw"
    }
  )
}

# =============================================================================
# vpc endpoint
# =============================================================================

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = concat(
    [aws_route_table.public.id], 
    aws_route_table.private[*].id
    )

  tags = merge(var.common_tags, 
   { 
    Name = "${var.region}-s3-vpc-enpoint"
   }
  )
}

# =============================================================================
# nat gateway
# =============================================================================

resource "aws_eip" "nat" {
  domain = "vpc"
  count  = min(length(var.subnet_private_cidrs), length(var.azs))

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-nat-eip-${var.azs[count.index]}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count             = length(aws_eip.nat)
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = aws_subnet.public[count.index].id
  connectivity_type = "public"

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-nat-${var.azs[count.index]}"
    }
  )

  # a nat gateway still needs a internet gateway to function but it does not reference it.
  # Whit this we add a dependency so we are sure that the internet gaway exisits before the nat gateway is created.
  depends_on = [aws_internet_gateway.main]

}


# =============================================================================
# subnets
# =============================================================================

resource "aws_subnet" "public" {
  count             = min(length(var.subnet_public_cidrs), length(var.azs)) # the current count is 3 because 3 azs are in the variable. 
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.subnet_public_cidrs[count.index]

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-public-subnet-${var.azs[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = min(length(var.subnet_private_cidrs), length(var.azs)) # the current count is 3 because 3 az are in the variable
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.subnet_private_cidrs[count.index]

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-private-subnet-${var.azs[count.index]}"
    }
  )
}

# =============================================================================
# routing tables
# =============================================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-route_table-public"
    }
  )
}

resource "aws_route_table" "private" {
  count  = length(aws_nat_gateway.main)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-route_table-private-${var.azs[count.index]}"
    }
  )
}

# =============================================================================
# routing association
# =============================================================================

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


