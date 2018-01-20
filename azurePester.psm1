<#
    .SYNOPSIS
    Check the status of Virtual Machine by Pester
#>

function Test-AzRmVm {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]$vm,
        [Parameter()]
        [ValidateSet("Should Be", "Should BeExactly", "Should Match")]
        [String]$Method = "Should Be",
        [String]$Name,
        [String]$Location,
        [String]$VmSize,
        [String]$OsType,
        [String]$PrivateIpAddress,
        [String]$AdminUsername,
        [Int]$DataDisks_Count
    )

    function Get-VmPrivateIPAddress{
        param(
            [string]$NetworkInterfacesId
        )

        $re = New-Object regex("\/resourceGroups\/(.*)\/providers\/")
        $ResourceGroupName = $re.Matches($NetworkInterfacesId).Groups[1].Value

        $re = New-Object regex("Microsoft.Network\/networkInterfaces\/(.*)")
        $nicName = $re.Matches($NetworkInterfacesId).Groups[1].Value

        $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $ResourceGroupName

        return $nic.IpConfigurations[0].PrivateIpAddress
    }

    Describe "Checking Virtual Machine" {
        if($name){
            it "VM name $Method $name" {
                switch ($Method) {
                    "Should Be"         { $vm.Name | Should Be $name }
                    "Should BeExactly"  { $vm.Name | Should BeExactly $name }
                    "Should Match"      { $vm.Name | Should Match $name } 
                }
            }
        }

        if($Location){
            it "VM location $Method $Location" {
                switch ($Method) {
                    "Should Be"         { $vm.Location | Should Be $Location }
                    "Should BeExactly"  { $vm.Location | Should BeExactly $Location }
                    "Should Match"      { $vm.Location | Should Match $Location }
                }
            }
        }

        if($VmSize){
            it "VM size $Method $VmSize" {
                switch ($Method) {
                    "Should Be"         { $vm.HardwareProfile.VmSize | Should Be $VmSize }
                    "Should BeExactly"  { $vm.HardwareProfile.VmSize | Should BeExactly $VmSize }
                    "Should Match"      { $vm.HardwareProfile.VmSize | Should Match $VmSize }
                }
            }
        }

        if($OsType){
            it "OsType $Method $OsType" {
                switch ($Method) {
                    "Should Be"         { $vm.StorageProfile.OsDisk.OsType | Should Be $OsType }
                    "Should BeExactly"  { $vm.StorageProfile.OsDisk.OsType | Should BeExactly $OsType }
                    "Should Match"      { $vm.StorageProfile.OsDisk.OsType | Should Match $OsType }
                }
            }
        }

        if($PrivateIpAddress){
            it "PrivateIpAddress $Method $PrivateIpAddress" {
                switch ($Method) {
                    "Should Be"         { Get-VmPrivateIPAddress($vm.NetworkProfile.NetworkInterfaces[0].id) | Should Be $PrivateIpAddress }
                    "Should BeExactly"  { Get-VmPrivateIPAddress($vm.NetworkProfile.NetworkInterfaces[0].id) | Should BeExactly $PrivateIpAddress }
                    "Should Match"      { Get-VmPrivateIPAddress($vm.NetworkProfile.NetworkInterfaces[0].id) | Should Match $PrivateIpAddress }
                }
                
            }
        }

        if($AdminUsername){
            it "AdminUsername $Method $AdminUsername" {
                switch ($Method) {
                    "Should Be"         { $vm.OSProfile.AdminUsername | Should Be $AdminUsername }
                    "Should BeExactly"  { $vm.OSProfile.AdminUsername | Should BeExactly $AdminUsername }
                    "Should Match"      { $vm.OSProfile.AdminUsername | Should Match $AdminUsername }
                }
            }           
        }

        if($DataDisks_Count){
            it "DataDisks_Count $Method $DataDisks_Count" {
                switch ($Method) {
                    "Should Be"         { $vm.StorageProfile.DataDisks.Count | Should Be $DataDisks_Count }
                    "Should BeExactly"  { $vm.StorageProfile.DataDisks.Count | Should BeExactly $DataDisks_Count }
                    "Should Match"      { $vm.StorageProfile.DataDisks.Count | Should Match $DataDisks_Count }
                }
                
            }                
        }
    }
}

Export-ModuleMember -Function Test-AzRmVm

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