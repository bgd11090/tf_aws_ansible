provider "aws" {
  profile = "aws"
  region  = "us-east-1"
}

resource "aws_vpc" "aws_tf_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "frontend_subnet_1" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags              = {
    Name = "Frontend Subnet 1"
  }
}

resource "aws_subnet" "frontend_subnet_2" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags              = {
    Name = "Frontend Subnet 2"
  }
}

resource "aws_subnet" "frontend_subnet_3" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags              = {
    Name = "Frontend Subnet 3"
  }
}

resource "aws_subnet" "backend_subnet_1" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags              = {
    Name = "Backend Subnet 1"
  }
}

resource "aws_subnet" "backend_subnet_2" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags              = {
    Name = "Backend Subnet 2"
  }
}

resource "aws_subnet" "backend_subnet_3" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"

  tags              = {
    Name = "Backend Subnet 3"
  }
}

resource "aws_subnet" "database_subnet_1" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1a"

  tags              = {
    Name = "Database Subnet 1"
  }
}

resource "aws_subnet" "database_subnet_2" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"

  tags              = {
    Name = "Database Subnet 2"
  }
}

resource "aws_subnet" "database_subnet_3" {
  vpc_id            = aws_vpc.aws_tf_vpc.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "us-east-1c"

  tags              = {
    Name = "Database Subnet 3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aws_tf_vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.backend_subnet_2.id

  tags = {
    Name = "NAT"
  }
}

resource "aws_route_table" "frontend_route_table" {
  vpc_id = aws_vpc.aws_tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Frontend Route Table"
  }
}

resource "aws_route_table" "backend_route_table" {
  vpc_id = aws_vpc.aws_tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Backend Route Table"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.aws_tf_vpc.id
  
  tags = {
    Name = "Database Route Table"
  }
}

resource "aws_route_table_association" "frontend_subnet_association_1" {
  subnet_id      = aws_subnet.frontend_subnet_1.id
  route_table_id = aws_route_table.frontend_route_table.id
}

resource "aws_route_table_association" "frontend_subnet_association_2" {
  subnet_id      = aws_subnet.frontend_subnet_2.id
  route_table_id = aws_route_table.frontend_route_table.id
}

resource "aws_route_table_association" "frontend_subnet_association_3" {
  subnet_id      = aws_subnet.frontend_subnet_3.id
  route_table_id = aws_route_table.frontend_route_table.id
}

resource "aws_route_table_association" "backend_subnet_association_1" {
  subnet_id      = aws_subnet.backend_subnet_1.id
  route_table_id = aws_route_table.backend_route_table.id
}

resource "aws_route_table_association" "backend_subnet_association_2" {
  subnet_id      = aws_subnet.backend_subnet_2.id
  route_table_id = aws_route_table.backend_route_table.id
}

resource "aws_route_table_association" "backend_subnet_association_3" {
  subnet_id      = aws_subnet.backend_subnet_3.id
  route_table_id = aws_route_table.backend_route_table.id
}

resource "aws_route_table_association" "database_subnet_association_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_route_table_association" "database_subnet_association_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_route_table_association" "database_subnet_association_3" {
  subnet_id      = aws_subnet.database_subnet_3.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_instance" "ec2_frontend_AZ1" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.frontend_subnet_1.id
  associate_public_ip_address = true
 #key_name      = "ssh-key"
  key_name      = "TF_key"
  security_groups = [aws_security_group.my_alb_sg.id]

  tags = {
    Name = "EC2_Frontend_AZ1"
  }
}


/*
resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkiIw5KNR8otDwuqtRT2G4rosJb44ssvLs5WlDcxG8zKfCk3rC3R/yg+Bi3XwlPIYnCtDcB0isnmZ0RoTzEco81Pk7LAqDPf5E0SrHFExnY5boSXD46EgalMuTPSvhpuz7OJpmTmrqOjka1eK8YuEjAmQ1ndmx5sv/wvoOSUrtJ7uLSghBbR5PrD/Q6cV2p9NavXj12TIrwywzfKgoTP6zK+NgvQVDZDaRUjvIrjVcMFLCQNZC2PflPz25Hi2OFL/x30tuSM4iOh5hcj9eQgZnmGjzmfr8UA8TAIwPyV6R+US89OucA83ZBAw7wtNX3AWd2InIb+kMzJV3VedHwaYJ root@localhost.localdomain"
}

*/

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.ec2_frontend_AZ1.public_ip
}

resource "aws_instance" "ec2_backend_AZ2" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.backend_subnet_2.id
  security_groups = [aws_security_group.my_alb_sg.id]

  tags = {
    Name = "EC2_Backend_AZ2"
  }
}

resource "aws_instance" "ec2_database_AZ3" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.database_subnet_3.id
  security_groups = [aws_security_group.my_alb_sg.id]
  
  tags = {
    Name = "EC2_Database_AZ3"
  }
}

resource "aws_s3_bucket" "my_aws_tf_bucket" {
  bucket = "aws-static-content-bucket-dj"  
}

resource "aws_s3_bucket_policy" "my_aws_tf_bucket_policy" {
  bucket = "aws-static-content-bucket-dj"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.my_aws_tf_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws_tf_vpc.id

  health_check {
    protocol             = "HTTP"
    path                 = "/"
    port                 = "80"
    healthy_threshold    = 2
    unhealthy_threshold  = 2
    timeout              = 3
    interval             = 30
  }
}

resource "aws_lb_target_group_attachment" "ec2_frontend_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.ec2_frontend_AZ1.id
}

resource "aws_security_group" "my_alb_sg" {
  name        = "my-alb-sg"
  description = "Security group for my ALB"

  vpc_id = aws_vpc.aws_tf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyALBSecurityGroup"
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_alb_sg.id]
  subnets            = [aws_subnet.frontend_subnet_1.id, aws_subnet.frontend_subnet_2.id, aws_subnet.frontend_subnet_3.id]

  enable_deletion_protection = false

  tags = {
    Name = "MyALB"
  }
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

/*
#Here we need valid ssl sertificate that needs to be validated with route53 (13$ per/month)
resource "aws_lb_listener" "frontend_https" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
  
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:466913791346:certificate/def0c91c-f166-4078-8d19-316f965620f7"
}
*/


