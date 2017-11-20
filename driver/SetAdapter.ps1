$adapter = gwmi win32_networkadapterconfiguration | ? { $_.IPaddress -like "*10.5*"}
$i = 1
foreach($element in $adapter){
$adapterindex = $element.index
$newname = "PlayHide VPN"
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