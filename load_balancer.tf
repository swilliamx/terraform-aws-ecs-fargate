resource "aws_lb_target_group" "fsc_target_group" {
  deregistration_delay = var.deregistration_delay
  name                 = "${local.prefix}-target-group"
  port                 = var.target_port
  protocol             = var.target_protocol
  slow_start           = 0
  tags                 = merge({ Name = "${local.prefix}-target-group" }, local.common_tags)
  target_type          = var.target_type
  vpc_id = module.aws-vpc.vpc_id
  #vpc_id = "vpc-0055d1146a892cc4c"
  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    matcher             = "200"
    path                = var.health_check_path
//    port                = var.target_port
    protocol            = var.target_protocol
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "${local.prefix}-load-balancer"
  load_balancer_type = "application"
//  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids
  subnets            = module.aws-vpc.public_subnet_ids
  security_groups    = [aws_security_group.alb-sg.id]
  tags               = merge({ Name = "${local.prefix}-load-balancer" }, local.common_tags)
  depends_on         = [aws_security_group.alb-sg]
}

resource "aws_alb_listener" "elk-alb-listener" {
  load_balancer_arn = aws_lb.load_balancer.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  #certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn
  #ssl_policy        = var.ssl_policy
  default_action {
    target_group_arn = aws_lb_target_group.fsc_target_group.id
    type             = "forward"
  }
}

resource "aws_security_group" "alb-sg" {
  name        = "${local.prefix}-alb-sg"
  description = "ELB Allowed Ports"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  tags   = merge({ Name = "${local.prefix}-alb-sg" }, local.common_tags)
  vpc_id = module.aws-vpc.vpc_id
}