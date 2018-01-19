Import-Module ./azurePester.psm1

$vms = Get-AzureRmVM
$vm = $vms[0]

$vm | Test-AzRmVm -Name testvm `
            -VmSize Standard_B1s `
            -Location westeurope `
            -OsType Windows `
            -PrivateIpAddress 10.2.3.4