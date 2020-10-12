
#Prior to running below script use "Connect-VIServer" to vCenter server depending on location of snaps

#Running the get-vm cmdlet with the below syntax will pull all VM's whose name contains "Pre-Patch Snap". You can edit the string within the quotes to change search criteria

#get-vm | get-snapshot | where {$_.name -match "Pre-Patch Snap"} | Format-Table -property VM,Name,Created,Description,SizeMB




#Running the script below will delete all VM's whose name contains "Pre-Patch Snap" 5 at a time. Run the get-vm search above to review snapshots identified by search string before removing.

$Date = "2/29/2020"
$SnapShotName = "Pre-Patch Snap"

$maxtasks = 5
 
$snaps = get-vm | get-snapshot | where {($_.name -match "$SnapShotName") -and ($_.created -match "$Date*")}
 
$i = 0
while($i -lt $snaps.Count){
 Remove-Snapshot -Snapshot $snaps[$i] -RunAsync -Confirm:$false
 $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
 while($tasks.Count -gt ($maxtasks-1)) {
 sleep 30
 $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
     }
     $i++
}
