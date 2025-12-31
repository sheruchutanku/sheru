
provider "aws" {
  region = "us-east-1"

}

terraform {
  backend "s3" {}
}


resource "aws_vpc" "harishvpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "HARISH-VPC"
  }
}


resource "aws_subnet" "harishsubnet" {
  vpc_id            = aws_vpc.harishvpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-Subnet"
  }
}


resource "aws_subnet" "harishsubnet1" {
  vpc_id            = aws_vpc.harishvpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public-Subnet1"
  }
}



resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.harishvpc.id
  tags = {
    Name = "My-VPC-Internet Gateway"
  }
}



resource "aws_route_table" "harishpublic" {
  vpc_id = aws_vpc.harishvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "PUBLIC"
  }
}




resource "aws_route_table_association" "my_vpc_us-east-1a_public" {
  subnet_id      = aws_subnet.harishsubnet.id
  route_table_id = aws_route_table.harishpublic.id
}




resource "aws_route_table_association" "my_vpc_us-east-1b_public" {
  subnet_id      = aws_subnet.harishsubnet1.id
  route_table_id = aws_route_table.harishpublic.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-all-traffic-ssh"
  description = "Allow all ingress and egress traffic including SSH"
  vpc_id      =  aws_vpc.harishvpc.id

  ingress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-all-ssh"
  }
}
/*
####################################################################################################



resource "aws_instance" "kopal" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name      = "testkey"
   vpc_security_group_ids = [ "${aws_security_group.allow_ssh.id}" ]
  subnet_id                   = aws_subnet.harishsubnet.id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              echo "harish" > /var/www/html/index.html
              mkdir -p /var/www/html/maa
              echo "maa" > /var/www/html/maa/index.html
              systemctl enable apache2
              systemctl start apache2
EOF
  tags = {
    Name = "HARRY"
  }
}


resource "aws_instance" "kopal1" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name      = "testkey"
   vpc_security_group_ids = [ "${aws_security_group.allow_ssh.id}" ]
  subnet_id                   = aws_subnet.harishsubnet1.id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              echo "harish1" > /var/www/html/index.html
              mkdir -p /var/www/html/papa
              echo "papa" > /var/www/html/papa/index.html
              systemctl enable apache2
              systemctl start apache2
EOF
  tags = {
    Name = "HARRY1"
  }
}


####################################################################################################

resource "aws_alb" "alb_front" {
  name     = "front-alb"
  internal = false
  security_groups    =    [ "${aws_security_group.allow_ssh.id}" ]
  subnets                    = ["${aws_subnet.harishsubnet.id}", "${aws_subnet.harishsubnet1.id}"]
  load_balancer_type = "application"
  enable_deletion_protection = false
}



resource "aws_alb_target_group" "tg-1" {
  name     = "tg-1"
  vpc_id   = aws_vpc.harishvpc.id
  port     = "80"
  protocol = "HTTP"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}


resource "aws_alb_target_group" "tg-2" {
  name     = "tg-2"
  vpc_id   = aws_vpc.harishvpc.id
  port     = "80"
  protocol = "HTTP"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}


resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = aws_alb_target_group.tg-1.arn
  target_id        = aws_instance.kopal.id
  port             = 80
}



resource "aws_alb_target_group_attachment" "alb_backend-02_http" {
  target_group_arn = aws_alb_target_group.tg-2.arn
  target_id        = aws_instance.kopal1.id
  port             = 80
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = aws_alb.alb_front.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg-1.arn
  }
}


###############################################################################

resource "aws_lb_listener_rule" "maa" {
  listener_arn = "${aws_lb_listener.my-test-alb-listner.arn}"
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg-1.arn

  }
  condition {
    path_pattern {
      values = ["/maa/*"]
     }
   }
}

resource "aws_lb_listener_rule" "papa" {
  listener_arn = "${aws_lb_listener.my-test-alb-listner.arn}"
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg-2.arn

  }
  condition {
    path_pattern {
      values = ["/papa/*"]
     }
   }
}




# Create NLB
resource "aws_lb" "nlb" {
  name               = "web-nlb"
  load_balancer_type = "network"
  internal           = false
   security_groups    =    [ "${aws_security_group.allow_ssh.id}" ]
  subnets            = ["${aws_subnet.harishsubnet.id}", "${aws_subnet.harishsubnet1.id}"]
}

# Create target group
resource "aws_lb_target_group" "tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.harishvpc.id
}

# Register both EC2 instances with the target group
resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        =  aws_instance.kopal.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        =  aws_instance.kopal1.id
  port             = 80
}


# Create listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
*/
###
