output "key_arn" {
  description = "The kms key arn"
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "The kms key id"
  value       = aws_kms_key.this.id
}

output "key_alias_arn" {
  description = "The kms key alias arn"
  value       = aws_kms_alias.this.arn
}

output "key_alias_id" {
  description = "The kms key alias id"
  value       = aws_kms_alias.this.id
}