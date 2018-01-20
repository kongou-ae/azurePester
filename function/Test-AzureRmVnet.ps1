<#
    .SYNOPSIS
    Check the status of Virtual Network by Pester
#>
function Test-AzRmVnet {

  [CmdletBinding()]
  param(
      [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
      [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork]$vnet,
      [Parameter()]
      [ValidateSet("Should Be", "Should BeExactly", "Should Match")]
      [String]$Method = "Should Be",
      [String]$Name,
      [String]$Location,
      [System.Array]$AddressPrefixes,
      [System.Array]$DnsServers
  )

  Describe "Checking Virtual Network" {
      if($Name){
          it "Vnet name $Method $Name" {
              switch ($Method) {
                  "Should Be"         { $vnet.Name | Should Be $Name }
                  "Should BeExactly"  { $vnet.Name | Should BeExactly $Name }
                  "Should Match"      { $vnet.Name | Should Match $Name } 
              }
          }
      }

      if($Location){
          it "Vnet location $Method $Location" {
              switch ($Method) {
                  "Should Be"         { $vnet.Location | Should Be $Location }
                  "Should BeExactly"  { $vnet.Location | Should BeExactly $Location }
                  "Should Match"      { $vnet.Location | Should Match $Location } 
              }
          }
      }

      if($AddressPrefixes){
          it "Vnet AddressPrefixes $Method $AddressPrefixes" {
              switch ($Method) {
                  "Should Be"         { $vnet.AddressSpace.AddressPrefixes -join "," | Should Be ($AddressPrefixes -join ",") }
                  "Should BeExactly"  { $vnet.AddressSpace.AddressPrefixes -join "," | Should BeExactly ($AddressPrefixes -join ",") }
                  "Should Match"      { $vnet.AddressSpace.AddressPrefixes -join "," | Should Match ($AddressPrefixes -join ",") }
              }
          }
      }

      if($DnsServers){
          it "DnsServers $Method $DnsServers" {
              switch ($Method) {
                  "Should Be"         { $vnet.DhcpOptions.DnsServers -join "," | Should Be ($DnsServers -join ",") }
                  "Should BeExactly"  { $vnet.DhcpOptions.DnsServers -join "," | Should BeExactly ($DnsServers -join ",") }
                  "Should Match"      { $vnet.DhcpOptions.DnsServers -join "," | Should Match ($DnsServers -join ",") }
              }
          }
      }
  }
}

Export-ModuleMember -Function Test-AzRmVnet