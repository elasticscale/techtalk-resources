
locals {
  image_repo_url = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/php-app"
}

resource "aws_cloudwatch_log_group" "php_app" {
  name              = "/ecs/php-app"
  retention_in_days = 7
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.12.1"

  cluster_name = "level3-integrated"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }

  services = {
    php-app = {
      cpu    = 256
      memory = 512

      container_definitions = {
        php-app = {
          cpu       = 256
          memory    = 512
          essential = true
          image     = "${local.image_repo_url}:latest"

          port_mappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            }
          ]

          environment = [
            {
              name  = "APP_NAME"
              value = "Level3App"
            }
          ]

          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "/ecs/php-app"
              awslogs-region        = var.region
              awslogs-stream-prefix = "ecs"
            }
          }
        }
      }

      subnet_ids = module.vpc.public_subnets

      security_group_rules = {
        http = {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        all_egress = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      assign_public_ip = true
    }
  }

  tags = {
    Environment = "Dev"
    Project     = "Level3"
  }

  depends_on = [aws_cloudwatch_log_group.php_app]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "level3-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.region}a", "${var.region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.5.0"

  repository_name         = "php-app"
  create                  = true
  create_lifecycle_policy = false
}