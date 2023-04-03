output "ip" {
  description = "GHCR Secret KMS Key ID"
  value       = aws_ecs_service.this.network_configuration
}
