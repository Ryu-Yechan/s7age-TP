output "master_instance_id" {
  value = aws_instance.master.id
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "worker_instance_ids" {
  value = aws_instance.worker[*].id
}

output "worker_private_ips" {
  value = aws_instance.worker[*].private_ip
}

output "all_instance_ids" {
  value = concat([aws_instance.master.id], aws_instance.worker[*].id)
}