
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.env_name}reservelocksubnet"
  subnet_ids = var.subnet_ids
  description = "${var.env_name}"

}


resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.env_name}reservelock"
  description = "${var.env_name}created demo cluster"
  engine         = "redis"
  engine_version = "7.1"
  node_type      = "cache.t4g.micro"
  port           = 6379
  parameter_group_name = "default.redis7.cluster.on"
  cluster_mode = "enabled"
  num_node_groups         = 1
  replicas_per_node_group = 0
  automatic_failover_enabled = true
  multi_az_enabled           = false
  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [var.redis_sg_id]
  at_rest_encryption_enabled  = true
  transit_encryption_enabled = true
}