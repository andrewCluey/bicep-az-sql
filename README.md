# bicep-az-sql
Bicep module to deploy an Azure SQL Server and databases.

##

The following example deploys a SQL Server in the UK South region, along with 2 database ('myappDb' and 'myappDb2') and an Azure AD user as the SQL Administrator. You can see that these 2 databases are deployed with different SKUs.

```js
module sql '../../main.bicep' = {
  name: 'sql'
  params:{
    environment: 'dev'
    application: 'myapp'
    location: 'uksouth'
    serverAdminObjectId: '7fygioT-35b2-55cb-a173-7865383edf34'
    serverAdminUserName: 'sqlAdmin'
    principalType: 'User'
    
    sqlDatabases: [
      {
        name: 'myappDb'
        skuName: 'S1'
        tier: 'Standard'
      }
      {
        name: 'myappDb2'
        skuName: 'GP_S_Gen5_1'
        tier: 'GeneralPurpose'
      }
    ]

    tags: {
      owner: 'me'
    }

  }
}
```
