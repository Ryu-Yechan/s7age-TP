locals {
  is_back= terraform.workspace == "back"
  projec_name = local.is_back ? "dev" : terraform.workspace
  worker_instance_types = [
    "t3.large",
    "t3.medium",
    "t3.medium",
    "t3.small"
  ]

  worker_disk_sizes = [
  20,   # worker1: 20GiB
  50,   # worker2: 50GiB
  8,     # worker3: 8GiB
  8
]
}


resource "aws_instance" "master" {
  ami                    = var.ami_id
  instance_type          = "t3.medium"
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.node_sg_id, var.stage_boangroup_id]
  key_name               = var.key_name
  # user_data를 사용하여 Ansible과 SSM Agent 설치
  user_data = file("${path.module}/install_ansible_ssm.sh")

  metadata_options {
    http_endpoint = "enabled"  # 메타데이터 서비스 활성화
    http_tokens   = "optional"
  }
  root_block_device {
    volume_size           = 20        # 20GiB
    volume_type           = "gp3"     # 최신 SSD 타입
    delete_on_termination = true
    encrypted             = true
  }
  iam_instance_profile   = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null

  tags = {
    Name    = "${var.env_name}_stage_k3s_master"
    Project = "${local.projec_name}_master"
    NodeName = "master"
  }
}

resource "aws_instance" "worker" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = local.worker_instance_types[count.index] #count.index == 0 ? "t3.medi" : "t3.medium"
  subnet_id              = count.index == 1 ? var.private_subnet_a_id : var.private_subnet_b_id
  vpc_security_group_ids = [var.node_sg_id, var.stage_boangroup_id]
  key_name               = var.key_name
  user_data = file("${path.module}/install_ansible_ssm.sh")
  metadata_options {
    http_endpoint = "enabled"  # 메타데이터 서비스 활성화
    http_tokens   = "optional"
  }
  root_block_device {
    volume_size           = local.worker_disk_sizes[count.index]
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  iam_instance_profile   = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null

  tags = {
    Name    = "${var.env_name}_stage-k3s-worker${count.index + 1}"
    Project = "${local.projec_name}_worker"
    NodeName = "worker${count.index + 1}"

    Role = lookup(
      var.worker_roles,
      "worker${count.index + 1}",
      "general"
    ) 
  }
}

/*
resource "aws_instance" "db" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.node_sg_id, var.stage_boangroup_id]
  key_name               = var.key_name
  user_data = file("${path.module}/install_ansible_ssm.sh")
  metadata_options {
    http_tokens = "required"  # IMDSv2를 필수로 설정
    http_endpoint = "enabled"  # 메타데이터 서비스 활성화
    http_tokens   = "optional"
  }
  iam_instance_profile   = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null

  tags = {
    Name    = "${var.env_name}_stage_k3s_DB"
    Project = "${local.projec_name}_master"
  }
}*/