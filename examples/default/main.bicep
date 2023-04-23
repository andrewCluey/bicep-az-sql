
module sql '../../main.bicep' = {
  name: 'sql'
  params:{
    environment: 'dev'
    application: 'myapp'
    location: 'uksouth'
    serverAdminObjectId: '7f8e4746-09b3-49cb-b197-0591383edca5'
    serverAdminUserName: 'clureA'
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
