# Kubernetes - 클러스터 리소스 매니페스트

## 개요
K3s 클러스터에 배포되는 Kubernetes 리소스 정의입니다.
ArgoCD App of Apps 패턴으로 GitOps 배포를 구현합니다.

## 디렉토리 구조

```
k8s/
├── apps/            # ArgoCD Application 정의
│   ├── dev/         # 개발 환경
│   ├── prod/        # 운영 환경
│   └── main/        # 공통
├── ingress/         # 환경별 Ingress 리소스
│   ├── dev/
│   ├── prod/
│   └── main/
├── manifests/       # 서비스 배포 예시 (Kustomize)
│   ├── base/        # 공통 설정
│   └── overlays/    # 환경별 패치
├── namespace/       # Namespace 정의
└── values/          # Helm values 파일
```

## ArgoCD Applications

| Application | 설명 |
|-------------|------|
| `user-service` | 사용자 서비스 |
| `reserve-service` | 예약 서비스 |
| `payment-service` | 결제 서비스 |
| `other-service` | 기타 서비스 |
| `ingress-nginx` | Ingress Controller |
| `monitoring` | Prometheus + Grafana |
| `loki` | 로그 수집 |
| `otel-collector` | 메트릭/로그 수집기 |

## Helm Values

| 파일 | 용도 |
|------|------|
| `argocd-values.yaml` | ArgoCD 설정 |
| `ingress-nginx-values.yaml` | Ingress 설정 |
| `monitoring-values.yaml` | Prometheus/Grafana 설정 |
| `loki-values.yaml` | Loki 설정 |
| `otel-collector-values.yaml` | OTel Collector 설정 |

## 특징
- **Kustomize**: base/overlays로 환경별 설정 분리
- **GitOps**: ArgoCD 자동 동기화 (`prune`, `selfHeal`)
- **MSA 구조**: 각 서비스 레포를 참조하여 배포
