resource "aws_secretsmanager_secret" "auth" {
  name = "auth-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "produto" {
  name = "produto-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "producao" {
  name = "producao-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "pagamento" {
  name = "pagamento-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "pedido" {
  name = "pedido-secret"
  recovery_window_in_days = 0
}