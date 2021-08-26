resource "aws_ecs_cluster" "fargate" {
  name = var.aws_ecs_cluster
  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "fs-core-api-ecs-task-execution-role" {
  name = var.ecs_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
            "ecs.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Environment = var.tr_environment_type
    Owner = var.tr_resource_owner
  }
}


resource "aws_iam_policy" "ecs_policy_fsc" {
  name        = "ecs_policy_fsc"
  path        = "/"
  description = "ecs_policy_fsc"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "ec2:*",
          "ecs:*",
          "ecr:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "application-autoscaling:*",
          "logs:*",
          "tag:*",
          "resource-groups:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



resource "aws_iam_role_policy_attachment" "fsc_ecs_policy_attach" {
  role       = aws_iam_role.fs-core-api-ecs-task-execution-role.name
  policy_arn = aws_iam_policy.ecs_policy_fsc.arn
}


resource "aws_iam_role_policy_attachment" "fsc_ecs_policy_attach1" {
  role       = aws_iam_role.fs-core-api-ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.cloud_watch_logs
}

resource "aws_ecs_task_definition" "app_web" {
  family = var.ecs_task_definition
  network_mode = var.network_mode
  execution_role_arn = aws_iam_role.fs-core-api-ecs-task-execution-role.arn
  memory = var.memory
  cpu = var.cpu
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
  {
    name = "core-api-app",
    image = var.ecs_image
    essential = true,
    portMappings = [
      {
        containerPort = var.containter_port
      }
    ],
    "environment": var.my_env_variables,
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group = aws_cloudwatch_log_group.ecs_logs.name,
        awslogs-region = var.region,
        awslogs-stream-prefix = "fs-core-api-${var.tr_environment_type}"
      }
    }
  }
    ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "fs-core-api-${var.tr_environment_type}-ec2-service"
  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.app_web.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  #iam_role        = aws_iam_role.fs-core-api-ecs-task-execution-role.arn
//  depends_on      = [aws_iam_role_policy.]


  load_balancer {
    target_group_arn = aws_lb_target_group.fsc_target_group.arn
    container_name   = "core-api-app"
    container_port   = var.target_port
  }

  network_configuration {
    assign_public_ip = false
    subnets          = module.aws-vpc.private_subnet_ids
    security_groups  = [aws_security_group.ecs_fargate_sg.id]
  }

}
