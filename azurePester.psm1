<#
    .SYNOPSIS
    Check the status of Virtual Machine by Pester
#>

function Test-AzRmVm {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]$vm,
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
            it "VM name should be $name" {
                $vm.Name | Should Be $name
            }
        }

        if($Location){
            it "VM location should be $Location" {
                $vm.Location | Should Be $Location
            }
        }

        if($VmSize){
            it "VM size should be $VmSize" {
                $vm.HardwareProfile.VmSize | Should be $VmSize
            }
        }

        if($OsType){
            it "OsType should be $OsType" {
                $vm.StorageProfile.OsDisk.OsType | Should be $OsType
            }
        }

        if($PrivateIpAddress){
            it "PrivateIpAddress should be $PrivateIpAddress" {
                Get-VmPrivateIPAddress($vm.NetworkProfile.NetworkInterfaces[0].id) | Should be $PrivateIpAddress
            }
        }

        if($AdminUsername){
            it "AdminUsername should be $AdminUsername" {
                $vm.OSProfile.AdminUsername | Should be $AdminUsername
            }           
        }

        if($DataDisks_Count){
            it "DataDisks_Count should be $DataDisks_Count" {
                $vm.StorageProfile.DataDisks.Count | Should be $DataDisks_Count
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
        [String]$Name,
        [String]$Location,
        [System.Array]$AddressPrefixes,
        [System.Array]$DnsServers
    )

    Describe "Checking Virtual Network" {
        if($name){
            it "Vnet name should be $name" {
                $vnet.Name | Should Be $name
            }
        }

        if($Location){
            it "Vnet location should be $Location" {
                $vnet.Location | Should Be $Location
            }
        }

        if($AddressPrefixes){
            it "Vnet AddressPrefixes should be $AddressPrefixes" {
                $vnet.AddressSpace.AddressPrefixes -join "," | Should be ($AddressPrefixes -join ",")
            }
        }

        if($DnsServers){
            it "DnsServers should be $DnsServers" {
                $vnet.DhcpOptions.DnsServers -join "," | Should be ($DnsServers -join ",")
            }
        }
    }
}

Export-ModuleMember -Function Test-AzRmVnet