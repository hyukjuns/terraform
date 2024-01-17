# azurerm network module

### 자산 목록
- virtualnetwork
- subnet
- network security group

### 현재 구현
- 1개 VNET 생성
- N개 Subnet 생성
- 1개 NSG 생성
- N개 Subnet에 NSG 연결 (NSG 선택)

### 향후 구현
1. vnet peering
2. nat gateway
3. route table
4. subnet delegation
5. service endpoint