resource "random_id" "secret_id" {
  byte_length = 8
}

resource "aws_secretsmanager_secret" "docker_login_username" {
  name                    = "${var.project_name}-docker-login-username-${random_id.secret_id.hex}"
  description             = "Docker login username to avoid rate limit on Docker Hub for CodeBuild project ${var.project_name}"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-docker-username"
  }
}

resource "aws_secretsmanager_secret_version" "docker_login_username" {
  secret_id     = aws_secretsmanager_secret.docker_login_username.id
  secret_string = var.docker_login_username
}

resource "aws_secretsmanager_secret" "docker_login_password" {
  name                    = "${var.project_name}-docker-login-password-${random_id.secret_id.hex}"
  description             = "Docker login password to avoid rate limit on Docker Hub for CodeBuild project ${var.project_name}"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-docker-password-password"
  }
}

resource "aws_secretsmanager_secret_version" "docker_login_password" {
  secret_id     = aws_secretsmanager_secret.docker_login_password.id
  secret_string = var.docker_login_password
}
