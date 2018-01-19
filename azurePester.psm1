<#
    .SYNOPSIS
    Check the status of Virtual Machine by Pester
#>

function Test-AzRmVm {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]$vm,
        [string]$Name,
        [string]$Location,
        [string]$VmSize,
        [string]$OsType,
        [string]$PrivateIpAddress
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


    }
}

Export-ModuleMember -Function Test-AzRmVm