############################################################################
# Common tfvars
############################################################################
region              = "us-east-1"
app_name            = "tableau"
tr_environment_type = "DEVELOPMENT"
tr_resource_owner   = "Solomon Williams"

############################################################################
# VPC tfvars
############################################################################
availability_zones         = ["us-east-1a", "us-east-1b"]
public_subnet_cidr_blocks  = ["10.92.1.0/24", "10.92.2.0/24"]
private_subnet_cidr_blocks = ["10.92.3.0/24", "10.92.4.0/24"]
vpc_cidr                   = "10.92.0.0/16"

############################################################################
# ECS tfvars
############################################################################

aws_ecs_cluster = "ecs-fargate-cluster"
memory  = "16384"
cpu = "4096"
ecs_task_definition = "ecs-tableau-app"
network_mode = "awsvpc"
cloud_watch_logs = "app-web-fargate"
ecs_role = "fargate-task-execution-role"
ecs_sg = "ecs-fargate-securitygroup"
ecs_image = "249071352372.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest"
containter_port = 8080

############################################################################
# Load Balancer tfvars
############################################################################
deregistration_delay = 300
#domain_name          = ""
target_protocol      = "HTTP"
target_port          = 8080
target_type          = "ip"

listener_port        = 80
listener_protocol    = "HTTP"
ssl_policy           = "ELBSecurityPolicy-2016-08"
healthy_threshold    = 5
interval             = 30
timeout              = 5
unhealthy_threshold  = 10
health_check_enabled = true
health_check_path    = "/"