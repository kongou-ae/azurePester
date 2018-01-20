<#
    .SYNOPSIS
    Check the status of Storage Account by Pester
#>

function Test-AzRmStorageAccount {

  [CmdletBinding()]
  param(
      [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
      [Microsoft.Azure.Commands.Management.Storage.Models.PSStorageAccount]$StorageAccount,
      [Parameter()]
      [ValidateSet("Should Be", "Should BeExactly", "Should Match")]
      [String]$Method = "Should Be",
      [String]$StorageAccountName,
      [String]$Location,
      [String]$SkuName,
      [String]$EnableHttpsTrafficOnly
  )

  Describe "Checking Storage Account" {
      if($StorageAccountName){
          it "Storage Account $Method $StorageAccountName" {
              switch ($Method) {
                  "Should Be"         { $StorageAccount.StorageAccountName | Should Be $StorageAccountName }
                  "Should BeExactly"  { $StorageAccount.StorageAccountName | Should BeExactly $StorageAccountName }
                  "Should Match"      { $StorageAccount.StorageAccountName | Should Match $StorageAccountName } 
              }
          }
      }

      if($Location){
          it "Storage Account location $Method $Location" {
              switch ($Method) {
                  "Should Be"         { $StorageAccount.Location | Should Be $Location }
                  "Should BeExactly"  { $StorageAccount.Location | Should BeExactly $Location }
                  "Should Match"      { $StorageAccount.Location | Should Match $Location }
              }
          }
      }

      if($SkuName){
          it "Storage Account size $Method $SkuName" {
              switch ($Method) {
                  "Should Be"         { $StorageAccount.Sku.Name | Should Be $SkuName }
                  "Should BeExactly"  { $StorageAccount.Sku.Name | Should BeExactly $SkuName }
                  "Should Match"      { $StorageAccount.Sku.Name | Should Match $SkuName }
              }
          }
      }

      if($EnableHttpsTrafficOnly){
          it "EnableHttpsTrafficOnly $Method $EnableHttpsTrafficOnly" {
              switch ($Method) {
                  "Should Be"         { $StorageAccount.EnableHttpsTrafficOnly | Should Be $EnableHttpsTrafficOnly }
                  "Should BeExactly"  { $StorageAccount.EnableHttpsTrafficOnly | Should BeExactly $EnableHttpsTrafficOnly }
                  "Should Match"      { $StorageAccount.EnableHttpsTrafficOnly | Should Match $EnableHttpsTrafficOnly }
              }
          }
      }
  }
}

Export-ModuleMember -Function Test-AzRmStorageAccount