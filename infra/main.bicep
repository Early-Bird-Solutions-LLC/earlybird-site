targetScope = 'resourceGroup'

@description('Short app name. Used as suffix for resource names and as a tag.')
param appName string = 'earlybird-site'

@description('Azure region for the Static Web App. DNS zones are global.')
param location string = 'eastus2'

@description('Apex domain for the site.')
param domainName string = 'earlybirdsolutions.com'

@description('GitHub repository URL the SWA is linked to. Recorded as metadata on the SWA resource — actual deploys use the deployment token from GitHub Actions.')
param repositoryUrl string = 'https://github.com/Early-Bird-Solutions-LLC/earlybird-site'

@description('Default branch the SWA tracks for production deploys.')
param branch string = 'main'

@description('When true, attach SWA custom domains for apex and www. Set false on first deploy (before registrar nameservers point at Azure DNS); set true on the second deploy after propagation.')
param attachCustomDomains bool = false

@description('TXT records at the apex (Google Workspace SPF, M365 verification, third-party verification tokens).')
param apexTxtRecords array = [
  [ 'v=spf1 include:_spf.google.com ~all' ]
  [ 'MS=ms19550658' ]
  [ 'kicl8um3ien582r6m0tf97dnrp' ]
  [ 'b1e658ac1d9747059ce36c70584f04bd4830b28be38ad7f57fa94ce4d7e03dc1' ]
  [ '5vo2b3pbgn9ljpqegehj86tfsf' ]
]

@description('Resource tags applied to every resource.')
param tags object = {
  app: appName
  env: 'prod'
  owner: 'jim@earlybirdsolutions.com'
  managedBy: 'bicep'
}

// ----------------------------------------------------------------------------
// Static Web App (Free tier, no source-linking - deploys via GitHub Actions
// with the deployment token retrieved out-of-band).
// ----------------------------------------------------------------------------
resource swa 'Microsoft.Web/staticSites@2024-11-01' = {
  name: 'swa-${appName}'
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  tags: tags
  properties: {
    repositoryUrl: repositoryUrl
    branch: branch
    provider: 'GitHub'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    deploymentAuthPolicy: 'DeploymentToken'
  }
}

// ----------------------------------------------------------------------------
// DNS zone (Azure DNS) — registrar nameservers must be flipped to the values
// in the `nameServers` output before this zone becomes authoritative.
// ----------------------------------------------------------------------------
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: domainName
  location: 'global'
  tags: tags
}

// MX — Google Workspace
resource mxApex 'Microsoft.Network/dnsZones/MX@2018-05-01' = {
  parent: dnsZone
  name: '@'
  properties: {
    TTL: 3600
    MXRecords: [
      { preference: 1,  exchange: 'aspmx.l.google.com' }
      { preference: 5,  exchange: 'alt1.aspmx.l.google.com' }
      { preference: 5,  exchange: 'alt2.aspmx.l.google.com' }
      { preference: 10, exchange: 'alt3.aspmx.l.google.com' }
      { preference: 10, exchange: 'alt4.aspmx.l.google.com' }
    ]
  }
}

// TXT at apex — SPF + verification tokens preserved from GoDaddy
resource txtApex 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  parent: dnsZone
  name: '@'
  properties: {
    TTL: 3600
    TXTRecords: [for txt in apexTxtRecords: {
      value: txt
    }]
  }
}

// DMARC at _dmarc — observe-only policy (p=none); collect reports before tightening.
resource dmarc 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  parent: dnsZone
  name: '_dmarc'
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [ 'v=DMARC1; p=none; rua=mailto:jim@earlybirdsolutions.com; ruf=mailto:jim@earlybirdsolutions.com; fo=1; aspf=r; adkim=r' ]
      }
    ]
  }
}

// CNAME www → SWA default hostname
resource cnameWww 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  parent: dnsZone
  name: 'www'
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: swa.properties.defaultHostname
    }
  }
}

// ALIAS at apex → SWA. Azure DNS resolves this dynamically (no IP pinning).
resource aliasApex 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  parent: dnsZone
  name: '@'
  properties: {
    TTL: 3600
    targetResource: {
      id: swa.id
    }
  }
}

// ----------------------------------------------------------------------------
// SWA custom domains. Only attach after registrar NS has been flipped to
// Azure DNS and propagation has completed (otherwise validation fails).
// ----------------------------------------------------------------------------
resource customDomainWww 'Microsoft.Web/staticSites/customDomains@2024-11-01' = if (attachCustomDomains) {
  parent: swa
  name: 'www.${domainName}'
  dependsOn: [
    cnameWww
  ]
  properties: {
    validationMethod: 'cname-delegation'
  }
}

resource customDomainApex 'Microsoft.Web/staticSites/customDomains@2024-11-01' = if (attachCustomDomains) {
  parent: swa
  name: domainName
  dependsOn: [
    aliasApex
  ]
  properties: {
    validationMethod: 'cname-delegation'
  }
}

// ----------------------------------------------------------------------------
// Outputs
// ----------------------------------------------------------------------------
output swaName string = swa.name
output swaDefaultHostname string = swa.properties.defaultHostname
output swaResourceId string = swa.id
output dnsZoneNameServers array = dnsZone.properties.nameServers
