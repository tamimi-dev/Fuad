# Read the comments if you need explanation, Fuad
# Below are the parameters for your env, ID, location, disk, VM and group names
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $SnapshotResourceId,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $Location,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $DiskName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName

)
# Below are self explatory
Write-Verbose "Creating New Disk"
$newDiskConfig = New-AzDiskConfig -Location $Location -CreateOption Copy -SourceResourceId $SnapshotResourceId
$newdisk = New-AzDisk -DiskName $DiskName -Disk $newDiskConfig -ResourceGroupName $ResourceGroupName -Verbose

Write-Verbose "Stopping Virtual Machine $VMName"
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
Stop-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Verbose -Force

Write-Verbose "Updating Operating System Disk"
Set-AzVMOSDisk -VM $vm -ManagedDiskId $newdisk.Id -Name $newdisk.Name -Verbose
Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName -Verbose

Write-Verbose "Starting Virtual Machine $VMName"
Start-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Verbose