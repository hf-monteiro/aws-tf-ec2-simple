################################################################################
# ALB Module
################################################################################
module "alb" {
  source = "../modules/alb"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "alb" {
  name        = "Terraform ALB SG"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id

  #Only ports 80 and 443 allowed from IPs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    description = "HTTP Allowed"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    description = "HTTPS Allowed"
    cidr_blocks = var.cidr_blocks
  }



  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = "All traffic out"
    # Lab/demo CIDR: restrict this to trusted networks before production use.
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_alb" "this" {
  name            = "Terraform-exampleshare-ALB"
  security_groups = ["${aws_security_group.alb.id}"]
  internal        = true
  subnets         = var.alb_vpc_id

}

resource "aws_alb_target_group" "group" {
  name     = "terraform-alb-target"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  stickiness {
    type = "lb_cookie"
  }
  # health_check {
  #   path = ""
  #   port = 80
  # }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}
