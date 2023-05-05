param environment string
param application string
param tags object = {}
param location string
param serverAdminObjectId string
param serverAdminUserName string

@allowed(['User', 'Group', 'Application'])
param principalType string 



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
resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
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


resource SVRAuditing 'Microsoft.Sql/servers/auditingSettings@2022-08-01-preview' = {
  name: 'default'
  parent: sqlServer
  properties: {
    storageAccountAccessKey: 'dssd'
    retentionDays: 91
    storageEndpoint: 'https://storageaccount.blob.core.windows.net'   
    state: 'Enabled'
  }
}

resource symbolicname 'Microsoft.Sql/servers/extendedAuditingSettings@2022-05-01-preview' = {
  name: 'default'
  parent: sqlServer
  properties: {
    isAzureMonitorTargetEnabled: true
    state: 'Enabled'
    storageAccountAccessKey: 'dssd'
    storageEndpoint: 'https://storageaccount.blob.core.windows.net'
    retentionDays: 91   
  }
}


resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  parent: sqlServer
  name: 'db1'
  location: location
  tags: assignedTags 

  // az sql db list-editions -l uksouth -o table
  sku: {
    name: 'S0'
    tier: 'Standard'
  }

  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    requestedBackupStorageRedundancy: 'Geo'
    isLedgerOn: false
   // collation: db.databaseCollation
   // catalogCollation: db.databaseCollation
    readScale: 'Disabled'
   // requestedBackupStorageRedundancy: 'Geo'
   // isLedgerOn: false
  }

  resource auditing 'auditingSettings' = {
    name: 'default'
    properties: {
      state: 'Enabled'
    }
  }
}

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
