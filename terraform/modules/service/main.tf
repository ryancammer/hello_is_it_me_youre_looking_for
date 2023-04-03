resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "hello_world-"
  retention_in_days = 1
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.app_environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_policy" "ghcr_read_only_policy" {
  name = "ghcr_read_only_policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "kms:Decrypt",
          "secretsmanager:GetSecretValue"
        ],
        Resource : [
          var.ghcr_secret_id,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ghcr_attachment" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = aws_iam_policy.ghcr_read_only_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role_attachment" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "hello_world"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn

  cpu    = 256
  memory = 512

  container_definitions = <<EOF
[
  {
    "name": "hello_world",
    "image": "${var.service_container_image_url}",
    "repositoryCredentials": {
      "credentialsParameter": "${var.ghcr_secret_id}"
    },
    "portMappings": [
        {
          "containerPort": 8080
        }
      ],
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name    = "hello_world"
  cluster = var.cluster_id

  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }
}
