resource "aws_vpc" "stage_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = false
  tags                 = { Name = "${var.env_name}stage-vpc" }
}

# 서브넷 3개
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.stage_vpc.id
  cidr_block              = var.public_a_cidr
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env_name}stage-public-subnet-a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.stage_vpc.id
  cidr_block              = var.public_b_cidr
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env_name}stage-public-subnet-b" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.stage_vpc.id
  cidr_block        = var.private_a_cidr
  availability_zone = "ap-northeast-2a"
  tags              = { Name = "${var.env_name}stage-private-subnet-a" } 
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.stage_vpc.id
  cidr_block        = var.private_b_cidr
  availability_zone = "ap-northeast-2b"
  tags              = { Name = "${var.env_name}stage-private-subnet-b" }
}

# 게이트웨이 설정
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.stage_vpc.id
  tags   = { Name = "${var.env_name}stage-gateway" }
}

# 라우팅 테이블: Public
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.stage_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.env_name}stage-public-routing" }
}


resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}
/*
# 기본 라우팅 테이블
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_vpc.stage_vpc.main_route_table_id  
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_vpc.stage_vpc.main_route_table_id  
}
*/

resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_b" {
  domain = "vpc"
}

# NAT Gateway (Public Subnet A에 생성)
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_a.id
  tags          = { Name = "${var.env_name}stage-gateway-a" }
  depends_on    = [aws_internet_gateway.igw]
}


# Private Subnet A와 B 각각에 NAT Gateway 연결된 라우팅 테이블 설정
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.stage_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
  tags = { Name = "${var.env_name}stage-private-routing-a" }
}

#라우팅테이블 연결
resource "aws_route_table_association" "private_assoc_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt_a.id
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_b.id
  tags          = { Name = "${var.env_name}stage-gateway-b" }
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.stage_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }
  tags = { Name = "${var.env_name}stage-private-routing-b" }
}

resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt_b.id
}


resource "aws_security_group" "alb_sg" {
  name        = "${var.env_name}alb-sg"
  vpc_id      = aws_vpc.stage_vpc.id
  description = "${var.env_name}ip"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "k3s_node_sg" {
  name        = "${var.env_name}k3s-node-sg"
  vpc_id      = aws_vpc.stage_vpc.id
  description = "${var.env_name}nodeport"
  /*
  # Ansible 접속을 위한 SSH 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
*/

  # 로드밸런서로부터 오는 트래픽 허용
  ingress {
    from_port       = 30080
    to_port         = 30080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "stage_boangroup" {
  name        = "${var.env_name}stage-boangroup"
  vpc_id      = aws_vpc.stage_vpc.id
  description = "${var.env_name}stage-boangroup created 2025-12-15T02:42:03.017Z"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "redis_sg" {
  name        = "${var.env_name}redis-sg"
  vpc_id      = aws_vpc.stage_vpc.id
  description = "${var.env_name}redis boangroup for reserve-service"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.k3s_node_sg.id, aws_security_group.stage_boangroup.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "self_host_runner" {
  name        = "${var.env_name}self host runner"
  vpc_id      = aws_vpc.stage_vpc.id
  description = "${var.env_name}self host runner"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
# Ansible
resource "aws_security_group" "launch_wizard_1" {
  name   = "${var.env_name}launch-wizard-1"
  vpc_id = aws_vpc.stage_vpc.id
}
*/

resource "aws_security_group" "elasticache_cloudshell_reservationlock" {
  name        = "${var.env_name}elasticache-cloudshell-reservationlock"
  description = "${var.env_name}Security group for CloudShell to securely connect to reservationlock. Modification could lead to connection loss."
  vpc_id      = aws_vpc.stage_vpc.id
}

resource "aws_security_group" "cloudshell_elasticache_reservationlock" {
  description = "${var.env_name}Security group attached to reservationlock to allow CloudShell to connect to the database. Modification could lead to connection loss."
  name        = "${var.env_name}cloudshell-elasticache-reservationlock"
  vpc_id      = aws_vpc.stage_vpc.id
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    self            = false
    security_groups = [aws_security_group.elasticache_cloudshell_reservationlock.id]
  }
}

# default SG는 name이 "default" 고정이라 리소스 블록을 따로 둠
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.stage_vpc.id
}


# 주의사항
/* 
# elasticache_cloudshell_reservationlock egress 설정 봐야함 **
$ terraform state show module.vpc.aws_security_group.elasticache_cloudshell_reservationlock
# module.vpc.aws_security_group.elasticache_cloudshell_reservationlock:
resource "aws_security_group" "elasticache_cloudshell_reservationlock" {
    arn         = "arn:aws:ec2:ap-northeast-2:449788867918:security-group/sg-07be0534ce5f418ed"
    description = "${var.env_name}Security group for CloudShell to securely connect to reservationlock. Modification could lead to connection loss."
    egress      = [
        {
            cidr_blocks      = []
            description      = null
            from_port        = 6379
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = [
                "sg-0a0c53b6985460f7d",
            ]
            self             = false
            to_port          = 6379
        },
    ]
    id          = "sg-07be0534ce5f418ed"
    ingress     = []
    name        = "${var.env_name}elasticache-cloudshell-reservationlock"
    name_prefix = null
    owner_id    = "449788867918"
    tags        = {}
    tags_all    = {}
    vpc_id      = "vpc-0898e2e4a7c3ee404"
}
*/