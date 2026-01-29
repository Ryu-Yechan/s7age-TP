############################################
# modules/iam/main.tf (최종본: 경고 제거 + plan 안정)
############################################

data "aws_caller_identity" "current" {}

locals {


  sns_statement = var.sns_topic_arn != "" ? [{
    Effect   = "Allow"
    Action   = ["sns:Publish"]
    Resource = var.sns_topic_arn
  }] : []

}

# =========================================================
# IAM Roles
# =========================================================

# EC2 SSM Role
resource "aws_iam_role" "ec2_ssm_role" {
  
  lifecycle {
    prevent_destroy = true
  }
  name = "EC2-SSM-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = 3600
}

# GitHub Actions ECR Push 역할
resource "aws_iam_role" "github_ecr_push" {
  
  lifecycle {
    prevent_destroy = true
  }
  name = "GitHubActionsECRPushRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:NakedFlower/NakedFlower:ref:refs/heads/back"
            ]
        }
      }
    }]
  })

  max_session_duration = 3600
}

# GitHub Actions S3 Deploy 역할
resource "aws_iam_role" "github_s3_deploy" {
  
  lifecycle {
    prevent_destroy = true
  }
  name = "GitHubActionsS3DeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:NakedFlower/STAGE:ref:refs/heads/front"
          ]
        }
      }
    }]
  })

  max_session_duration = 3600
}

# S7AGE Frontend Deploy 역할
resource "aws_iam_role" "s7age_frontend_deploy" {
  
  lifecycle {
    prevent_destroy = true
  }
  name = "github-actions-s7age-frontend-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:S7AGE/Front:ref:refs/heads/main"
          ]
        }
      }
    }]
  })

  max_session_duration = 3600
}

# K3s EBS 역할
resource "aws_iam_role" "k3s_ebs_role" {
  
  lifecycle {
    prevent_destroy = true
  }
  name = "k3s-ebs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = 3600
}

# EKS Auto Cluster 역할
resource "aws_iam_role" "eks_auto_cluster" {
  
  lifecycle {
    prevent_destroy = true
  }
  description          = "Allows access to other AWS service resources that are required to operate Auto Mode clusters managed by EKS."
  name = "StageAmazonEKSAutoClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = ["sts:AssumeRole", "sts:TagSession"]
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })


  max_session_duration = 3600
}

# EKS Auto Node 역할
resource "aws_iam_role" "eks_auto_node" {
  
  lifecycle {
    prevent_destroy = true
  }
  description          = "Allows EKS nodes to connect to EKS Auto Mode clusters and to pull container images from ECR."
  name = "StageAmazonEKSAutoNodeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  max_session_duration = 3600
}

# =========================================================
# Managed Policy Attachments (managed_policy_arns 경고 제거)
# =========================================================

# EC2 SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# GitHub ECR Push
resource "aws_iam_role_policy_attachment" "github_ecr_push_attach" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.github_ecr_push.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/GitHubActionsECRPushPolicy"
}

# GitHub S3 Deploy
resource "aws_iam_role_policy_attachment" "github_s3_deploy_attach" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.github_s3_deploy.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/GitHubActionsS3Policy"
}

# S7AGE Frontend Deploy
resource "aws_iam_role_policy_attachment" "s7age_frontend_deploy_attach" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.s7age_frontend_deploy.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/S7age.Front.S3"
}

# K3s EBS managed policies
resource "aws_iam_role_policy_attachment" "k3s_ebs_sns" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.k3s_ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_role_policy_attachment" "k3s_ebs_sqs" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.k3s_ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "k3s_ebs_ssm" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.k3s_ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "k3s_ebs_ebs_csi" {
  lifecycle {
    prevent_destroy = true
  }
  role       = aws_iam_role.k3s_ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# EKS Cluster managed policies
resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  lifecycle {
    prevent_destroy = true
  }
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  ])

  role       = aws_iam_role.eks_auto_cluster.name
  policy_arn = each.value
}

# EKS Node managed policies
resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  lifecycle {
    prevent_destroy = true
  }
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])

  role       = aws_iam_role.eks_auto_node.name
  policy_arn = each.value
}


# =========================================================
# Instance Profile
# =========================================================

resource "aws_iam_instance_profile" "ec2_profile" {
  lifecycle {
    prevent_destroy = true
  }
  name = "k3s-ebs-role"
  role = aws_iam_role.k3s_ebs_role.name

}

