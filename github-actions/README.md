# GitHub Actions - CI/CD 워크플로우

## 개요
프론트엔드/백엔드 배포 및 보안 스캔 워크플로우 예시입니다.
각 서비스 레포의 `.github/workflows/`에 복사하여 사용합니다.

## 워크플로우

### 프론트엔드 (`front-deploy.yml`)
React 앱을 S3 + CloudFront로 배포합니다.

```
Code Push (dev/main)
  → Semgrep (SAST)
  → npm build
  → OIDC로 AWS 인증
  → S3 업로드
  → CloudFront 캐시 무효화
```

**특징:**
- GitHub Environments (DEV/PROD) 분리
- OIDC 기반 AWS 인증 (시크릿 키 불필요)
- 브랜치별 환경 자동 선택

### 백엔드 (`backend-deploy.yml`)
Spring 앱을 GHCR로 빌드/푸시합니다.

```
Code Push (dev/main)
  → Semgrep (SAST)
  → Maven Build
  → Docker Build
  → Trivy (Image Scan)
  → GHCR Push
  → ArgoCD 자동 배포
```

**특징:**
- 브랜치별 DDL_AUTO 설정 (dev: update, prod: validate)
- HIGH/CRITICAL 취약점 발견 시 빌드 실패
- 이미지 태그: `dev` / `latest` + commit SHA

### 보안 스캔

| 파일 | 설명 |
|------|------|
| `zap-passive-scan.yml` | OWASP ZAP 패시브 스캔 |
| `zap-full-scan.yml` | OWASP ZAP 풀 스캔 (DAST) |

## 필요한 Secrets

### 프론트엔드
| Secret | 설명 |
|--------|------|
| `AWS_ROLE_ARN` | OIDC용 IAM Role ARN |
| `S3_BUCKET` | 배포 대상 S3 버킷 |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront 배포 ID |

### 백엔드
- `GITHUB_TOKEN` (자동 제공)
