output "ec2_ssm_role_arn" {
  value = aws_iam_role.ec2_ssm_role.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "github_ecr_push_role_arn" {
  value = aws_iam_role.github_ecr_push.arn
}

output "k3s_ebs_role_arn" {
  value = aws_iam_role.k3s_ebs_role.arn
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_auto_cluster.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_auto_node.arn
}