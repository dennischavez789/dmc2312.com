# Local Network Gateway

This module deploys Local Network Gateway, with resource lock.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/localNetworkGateways`|2020-08-01|
|`providers/locks`|2016-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `localAddressPrefixes` | array | Required. List of the local (on-premises) IP address ranges |  |  |
| `localAsn` | string | Optional. The BGP speaker's ASN. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |  |  |
| `localBgpPeeringAddress` | string | Optional. The BGP peering address and BGP identifier of this BGP speaker. Not providing this value will automatically disable BGP on this Local Network Gateway resource. |  |  |
| `localGatewayPublicIpAddress` | string | Required. Public IP of the local gateway |  |  |
| `localNetworkGatewayName` | string | Required. Name of the Local Network Gateway |  |  |
| `localPeerWeight` | string | Optional. The weight added to routes learned from this BGP speaker. This will only take effect if both the localAsn and the localBgpPeeringAddress values are provided. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Local Network Gateway from deletion. | False |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `localNetworkGatewayName` | string | The Name of the Local Network Gateway. |
| `localNetworkGatewayResourceGroup` | string | The name of the Resource Group the Local Network Gateway was created in. |
| `localNetworkGatewayResourceId` | string | The Resource Id of the Local Network Gateway. |

## Considerations

*N/A*

## Additional resources

- [What is VPN Gateway?](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)