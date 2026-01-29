# Docs - 문서 및 다이어그램

## 개요
프로젝트 아키텍처 다이어그램을 관리합니다.

## 파일

| 파일 | 설명 |
|------|------|
| `architecture-initial.png` | 초기 설계안 (EKS + ECR + RDS) |
| `architecture.png` | 최종 구현안 (K3s + GHCR + MySQL Pod) |

## 아키텍처 변경 이유

| 초기 설계 | 실제 구현 | 이유 |
|----------|----------|------|
| EKS | K3s (EC2) | 관리형 비용 절감 |
| ECR | GHCR | 무료 레지스트리 |
| RDS | MySQL Pod | DB 비용 절감 |

## 최종 구성 요약
- **CloudFront + S3**: 정적 프론트엔드
- **VPC 내 K3s**: Master 1 + Worker 4
- **Nginx Ingress**: MSA 트래픽 라우팅
- **ElastiCache (Redis)**: 세션/캐시
- **WAF**: 외부 공격 대비
