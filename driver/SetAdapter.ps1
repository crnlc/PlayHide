param(
[string]$name,
[string]$ip)

$adapter = gwmi win32_networkadapterconfiguration | ? { $_.IPaddress -like $ip}
$i = 1

foreach($element in $adapter){
$adapterindex = $element.index
$adapterID = gwmi win32_networkadapter | ?{$_.index -eq $adapterindex}
$adapter = ($adapterID).NetConnectionID
    $input = @"
interface set interface "$adapter" newname="$name"
exit
"@
$input
$input | netsh
$i++
}