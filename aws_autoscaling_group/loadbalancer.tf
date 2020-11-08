provider "aws" {
  region = var.region
}

resource "aws_security_group" "alb-sec-group" {
  name = "alb-sec-group"
  description = "Security Group for the ALB"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "autosg_sec_group" {
  name = "autosg_sec_group"
  description = "Security Group for the autosg"

  egress {
    from_port = 0
    protocol = "-1" // ALL Protocols
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Allow Inbound traffic from the ELB Security-Group
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
// Allow Inbound traffic from the ALB Sec-Group
    security_groups = [aws_security_group.alb-sec-group.id]
  }
}

// create ELB
resource "aws_lb" "ELB" {
  name               = "terraform-autosg"
  load_balancer_type = "application"

  subnets  = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb-sec-group.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ELB.arn
  port = 80
  protocol = "HTTP"

  // By default, return a simple 500 status page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "500 Internal Server Error"
      status_code  = "500"
    }
  }
}

resource "aws_lb_target_group" "autosg" {
  name = "autosg"
  port = var.ec2_instance_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "autosg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.autosg.arn
  }
  condition {
    path_pattern {
      values = ["/index.html"]
    }
  }
  condition {
     host_header {
      values = [
        "terraform-autosg-*.elb.amazonaws.com"]
    }
  }
//  terraform-autosg-*.elb.amazonaws.com
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "access_to_instances" {
  name = "access_to_instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["78.27.138.17/32", "76.169.181.157/32"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["78.27.138.17/32", "76.169.181.157/32"]
  }
  # Allow outgoing traffic to anywhere.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ALB_DNS_Name" {
  value = aws_lb.ELB.dns_name
  description = "Application LB DNS name"
}
