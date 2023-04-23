param environment string
param application string
param tags object = {}
param location string
param serverAdminObjectId string
param serverAdminUserName string


@allowed(['User', 'Group', 'Application'])
param principalType string 

@description('''
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
''')
param sqlDatabases array = [{
  dbName: 'db1'
}]


/*
@description('Enable/Disable Transparent Data Encryption')
@allowed([
  'Enabled'
  'Disabled'
])
param transparentDataEncryption string = 'Enabled'
*/


// variables
var tenantId = tenant().tenantId
var sqlServerName = 'sql-${environment}-${application}'
//var pepName = 'pepName'
var assignedTags = union(defaultTags, tags)
var defaultTags = {
  Environment: environment
  application: application
}


// resources
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: assignedTags
  properties: {
    version: '12.0'
    //minimalTlsVersion: 
    publicNetworkAccess: 'Disabled'
    //keyId: // future enhancement to allow customer managed key data encryption
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      tenantId: tenantId
      login: serverAdminUserName // Login name of the server administrator.
      principalType: principalType // User, Group, Application
      sid: serverAdminObjectId       // SID (object ID) of the server administrator.	
    } 
  }
  identity: {
    type: 'SystemAssigned'
  }
}


resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = [for db in sqlDatabases: {
  parent: sqlServer
  name: db.name
  location: location
  tags: assignedTags 

  // az sql db list-editions -l uksouth -o table
  sku: {
    name: ((!empty(db.skuName)) ? db.skuName : 'S0') // if skuName is not provided, set to 'S0'
    tier: ((!empty(db.tier)) ? db.tier : 'Standard') // if tier is not provided, set to 'Standard'
  }

  properties: {
   // collation: db.databaseCollation
   // catalogCollation: db.databaseCollation
    readScale: 'Disabled'
   // requestedBackupStorageRedundancy: 'Geo'
   // isLedgerOn: false
  }
}]


/*

resource encryption 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-11-01-preview' = {
  parent: sqlServerDatabase
  name: 'current'
  properties: {
    state: transparentDataEncryption
  }
}
*/



/*

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: pepName
  location: location
  tags: assignedTags
  properties: {
    subnet: pepSubnetId
    ipConfigurations: [
      {
        name: '${pepName}-ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddress:
          publicIPAddress:
          applicationGatewayBackendAddressPools:
          loadBalancerBackendAddressPools:
          loadBalancerInboundNatRules:
          primary: true
        }
      }
    ]   
  }    
}
*/
