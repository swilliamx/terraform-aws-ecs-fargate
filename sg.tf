resource "aws_security_group" "ecs_fargate_sg" {
  name        = var.ecs_sg
  description = "Security group for ecs fargate instance"
  vpc_id      = module.aws-vpc.vpc_id

  # HTTPS API Gateway
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Database
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.tr_environment_type
    Owner = var.tr_resource_owner
  }
}