### Mark kubeconfig as Sensitive Variable
```
export TF_ARM_AKS_KUBE_CONFIGS_SENSITIVE=true
```
### Tips
```
az aks get-credentials -g <RG_NAME> -n <CLUSTER_NAME>
```

### azurerm Provider Change Log
- ~> 3.0 (2023.08.04)
- 3.5 latest (20230531)
- 2.6.0 -> 3.4.0

### Ref
- AKS Hashicorp Docs
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#attributes-reference
- AKS Examples in hashicorp
    - https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/kubernetes
