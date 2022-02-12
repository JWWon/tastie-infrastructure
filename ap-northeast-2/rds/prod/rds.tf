resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
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

resource "aws_db_instance" "backend-main" {
  identifier        = "prod-backend-main"
  allocated_storage = "50"
  storage_type      = "gp2"
  storage_encrypted = true
  engine            = "postgres"
  engine_version    = "11.5"
  instance_class    = "db.t3.small"

  name     = "tastie" # dbname
  username = sensitive(data.aws_ssm_parameter.db-username-backend-main.value)
  password = sensitive(data.aws_ssm_parameter.db-password-backend-main.value)

  publicly_accessible        = true
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
  deletion_protection = false

  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
}
