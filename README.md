# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
environment    | Yes      |
application    | Yes      |
tags           | No       |
location       | Yes      |
serverAdminObjectId | Yes      |
serverAdminUserName | Yes      |
principalType  | Yes      |
sqlDatabases   | No       | An array of objects containing the database name, skuName, tier and capacity. EXAMPLE: [   {     name: "db1",     skuName: "S2",     tier: "Standard",     capacity: 100   },   {     name: "db2",     skuName: "GP_Gen5_6",     tier: "GP_Gen5",     capacity: 100   } ] 

### environment

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### application

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### serverAdminObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### serverAdminUserName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### principalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



- Allowed values: `User`, `Group`, `Application`

### sqlDatabases

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of objects containing the database name, skuName, tier and capacity.
EXAMPLE:
[
  {
    name: "db1",
    skuName: "S2",
    tier: "Standard",
    capacity: 100
  },
  {
    name: "db2",
    skuName: "GP_Gen5_6",
    tier: "GP_Gen5",
    capacity: 100
  }
]


## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "main.json"
    },
    "parameters": {
        "environment": {
            "value": ""
        },
        "application": {
            "value": ""
        },
        "tags": {
            "value": {}
        },
        "location": {
            "value": ""
        },
        "serverAdminObjectId": {
            "value": ""
        },
        "serverAdminUserName": {
            "value": ""
        },
        "principalType": {
            "value": ""
        },
        "sqlDatabases": {
            "value": [
                {
                    "dbName": "db1"
                }
            ]
        }
    }
}
```
