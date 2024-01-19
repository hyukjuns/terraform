### 자산 목록
- Azure Managed Disk

## 현재 구현
- Managed Disk 생성 및 VM 연결, 제거

### 향후 구현
- 사이즈 조정

### 특이사항
- 데이터디스크와 VM 의존성 부분
    - 가상머신 삭제 시 data disk 삭제 방지하도록 (랜덤 스트링으로 인해 삭제 되는듯)
