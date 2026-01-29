# Ansible - 서버 및 클러스터 자동화

## 개요
K3s 클러스터 구성 및 서비스 배포를 자동화하는 Ansible 구성입니다.
SSM 기반 원격 접속으로 Bastion 없이 Private 서버를 관리합니다.

## 디렉토리 구조

```
ansible/
├── ansible.cfg          # Ansible 설정
├── inventories/ssm/     # SSM 기반 인벤토리
├── playbooks/           # 실행 플레이북
├── roles/               # 역할별 태스크
└── collections/         # amazon.aws 컬렉션
```

## 주요 Role

| Role | 설명 |
|------|------|
| `k3s_master` | K3s 마스터 노드 설치 |
| `k3s_worker` | K3s 워커 노드 조인 |
| `ingress_nginx` | Nginx Ingress Controller |
| `argocd` | ArgoCD 설치 및 앱 연결 |
| `prometheus_stack` | Prometheus + Grafana |
| `loki` | 로그 수집 |
| `otelcol` | OpenTelemetry Collector |
| `db` | MySQL Pod 배포 |
| `secrets` | Vault 암호화 시크릿 관리 |

## 실행 예시

```bash
# 전체 클러스터 부트스트랩
ansible-playbook playbooks/bootstrap_all.yml

# K3s 클러스터만 구성
ansible-playbook playbooks/k3s_cluster.yml

# 모니터링 스택 배포
ansible-playbook playbooks/monitoring.yml
```

## 특징
- **SSM 기반 접속**: Bastion 없이 Private Subnet 관리
- **Vault 암호화**: 민감 정보 안전하게 관리
- **Terraform 연동**: Output 값을 인벤토리로 활용
