# Read the comments if you need explanation, Fuad
[CmdletBinding()]
param (
    # Your Azure disk name
    [Parameter(Mandatory = $true)]
    [string]
    $SourceDiskName,

    # Your Azure Group name
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,

    # Your Azure Snapshot name
    [Parameter(Mandatory = $false)]
    [string]
    $SnapshotName = $SourceDiskName + "_snapshot"
)

#Using the parameters listed above
$sourceDisk = Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $SourceDiskName
# creting the snapshot configuration
Write-Verbose "Creating The Snapshot Configuration"
$snapshotConfig = New-AzSnapshotConfig -SourceUri $sourceDisk.Id -Location $sourceDisk.Location -CreateOption Copy
# creting the snapshot 
Write-Verbose "Creating The Disk Snapshot"
$snapshot = New-AzSnapshot -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName -Snapshot $snapshotConfig

$obj = [PSCustomObject]@{
    ResourceId = $snapshot.Id
}
Write-Output $obj