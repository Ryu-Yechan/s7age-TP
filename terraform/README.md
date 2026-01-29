# Terraform - AWS 인프라 IaC

## 개요
AWS 인프라를 코드로 관리하는 Terraform 구성입니다.
Workspace 기반으로 `dev` / `prod` 환경을 분리하여 운영합니다.

## 구성 모듈

| 모듈 | 설명 |
|------|------|
| `vpc` | VPC, Subnet, Security Group |
| `compute` | EC2 인스턴스 (K3s Master/Worker) |
| `alb` | Application Load Balancer |
| `elasticache` | Redis 클러스터 |
| `s3` | 프론트엔드 정적 파일 호스팅 |
| `cloudfront` | CDN 배포 |
| `waf` | 웹 방화벽 |
| `route53` | DNS 관리 |
| `sqs` / `sns` | 메시지 큐 (예약 처리용) |
| `iam` | IAM Role 및 정책 |
| `github` | GitHub Actions OIDC 연동 |

## 사용법

```bash
# 워크스페이스 선택
terraform workspace select dev

# 계획 확인
terraform plan

# 적용
terraform apply
```

## 주요 특징
- **S3 Remote Backend**: tfstate 중앙 관리
- **DynamoDB State Lock**: 동시 실행 충돌 방지
- **환경별 변수 분리**: `terraform.tfvars` + workspace 조합
