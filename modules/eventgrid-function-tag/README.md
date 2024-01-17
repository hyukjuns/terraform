# Auto Tagging by EventGrid & Function
- Tag: 'Created by'
- Flow: EventGrid Subscription -> Activity Log -> Function -> run.ps1 -> tag to resource (Created by)

# Caution
- 배포 후 Function app -> Appfiles -> requirements.psd1 편집 필요
    ```
    'Az' = '9.*'
    ```

## Ref
1. Function
    - Runtime -> Powershell 7.2
    - Shell File -> run.ps1
    - Identity -> Systemassigned, Tag Contributor
    - Appfiles -> requirements.psd1 -> Enable 'Az' Module
2. EventGrid Subscription
    - Scope -> Azure Subscription (System Topic)
    - Event Type -> Resource Write Success