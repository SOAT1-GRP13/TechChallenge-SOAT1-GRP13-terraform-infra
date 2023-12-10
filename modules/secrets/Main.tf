resource "aws_secretsmanager_secret" "secrets" {
  name = "soat1-grp13-secret"
  recovery_window_in_days = 0
}