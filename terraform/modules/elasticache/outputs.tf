output "elasticache_endpoint" {
  description = "Configuration endpoint address for the Redis cluster"
  value       = aws_elasticache_replication_group.redis.configuration_endpoint_address
}

output "primary_endpoint" {
  description = "Primary endpoint address for the Redis cluster"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "replication_group_id" {
  value = aws_elasticache_replication_group.redis.replication_group_id
}

output "arn" {
  value = aws_elasticache_replication_group.redis.arn
}
