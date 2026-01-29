#! /bin/bash

# 현재 워크스페이스 확인
workspace=$(terraform workspace show)

# 워크스페이스에 맞는 tfvars 파일 설정
case $workspace in
  "prod")
    terraform plan -var-file="prod.tfvars"
    ;;
  "dev")
    terraform plan -var-file="dev.tfvars"
    ;;
  *)
    terraform plan
    ;;
esac