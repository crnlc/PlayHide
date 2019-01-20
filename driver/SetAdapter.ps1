param(
[string]$Name,
[string]$Subnet)

$adapter = gwmi win32_networkadapterconfiguration | ? { $_.IPaddress -like $Subnet}
$i = 1

foreach($element in $adapter){
$adapterindex = $element.index
$newname = $Name
$adapterID = gwmi win32_networkadapter | ?{$_.index -eq $adapterindex}
$adapter = ($adapterID).NetConnectionID
    $input = @"
interface set interface "$adapter" newname="$newname"
exit
"@
$input
$input | netsh
$i++
}