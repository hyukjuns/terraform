## Resources
```
- RG
    - AKS, VNET, ACR

- Role Assign
    - AKS AgentPool Identity (Kubelet's Identity) to ACR (AcrPill)
    - AKS Identity to VNET's RG (Contributor)

```

## Version Contstraints
```
# azurerm
~> 3.0
```
## Tip
### Mark kubeconfig as Sensitive Variable
```
export TF_ARM_AKS_KUBE_CONFIGS_SENSITIVE=true
```