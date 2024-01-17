# Azurerm Compute module

### 자산 목록
- VM
- VMSS

## 현재 구현
- N개 가상머신 생성
- OS 선택 3가지 (ubuntu,centos, windows)
- 공용 IP 생성

### 향후 구현
- VMSS 생성
- 가용성 집합, 가용성 영역 선택
- 모니터링 구성

### 특이사항
- Disk, Backup은 별도 모듈로 구현
- VM Sku 별로 OS Disk 사이즈 제한 존재
