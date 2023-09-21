resource "aws_security_group" "nsg_ec2_webapp" {
  name   = "ec2_allow_8080"
  vpc_id = var.vpc_id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "nsg_alb_webapp" {
  name   = "alb_allow_80"
  vpc_id = var.vpc_id

  ingress {
    description = "80 from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_launch_template" "lt_webapp" {
  name_prefix            = var.asg_lt_tagging
  image_id               = var.ami_id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.nsg_ec2_webapp.id]
}

resource "aws_lb" "alb_webapp" {
  name                       = var.alb_tagging
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.nsg_alb_webapp.id]
  subnets                    = [var.public_subnet_1a_id, var.public_subnet_1b_id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "alb_tg_webapp" {
  name     = "alb-targetgrp-webapp"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb_webapp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_webapp.arn
  }
}

resource "aws_autoscaling_group" "asg_webapp" {
  vpc_zone_identifier = [var.private_subnet_1a_id, var.private_subnet_1b_id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2

  launch_template {
    id      = aws_launch_template.lt_webapp.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.alb_tg_webapp.arn]
}