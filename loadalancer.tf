resource "aws_security_group" "load-balancer" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.main.id

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
}


# Target group 
resource "aws_lb_target_group" "target-group" {
  name          = "target-group"
  port          = 80
  protocol      = "HTTP"
  vpc_id        = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    protocol            = "HTTP"
    matcher             = "200"
  }
}



# Target group attachment 
resource "aws_lb_target_group_attachment" "web-attachment" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.node.id
  port             = 80
}



# AWS application load balancer
resource "aws_alb" "alb" {
  name = "alb"
  internal = false
  security_groups = [aws_security_group.load-balancer.id]
  subnets = [aws_subnet.public-1-subnet.id, aws_subnet.public-2-subnet.id]
}

# Application load balancer listener 
resource "aws_alb_listener" "alb_listener"{
 load_balancer_arn = aws_alb.alb.arn
 port               = "80"
 protocol           = "HTTP"
 default_action {
  target_group_arn = aws_lb_target_group.target-group.arn
  type             = "forward"
 }
}

