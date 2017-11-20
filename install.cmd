@echo off
echo "PlayHide Installation"
.\driver\tap.exe
echo "Firewall Settings will set"
netsh advfirewall firewall add rule name="VPN" dir=in action=allow protocol=UDP localport=1400
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
echo "PlayHide Adapter will set"
netsh interface ipv4 set interface "PlayHide VPN" metric=1
netsh interface set interface name="Ethernet 2" newname="PlayHide VPN"
netsh interface set interface name="LAN-Verbindung 2" newname="PlayHide VPN"
netsh interface set interface name="Local Area Connection 2" newname="PlayHide VPN"
netsh interface ipv4 set interface "PlayHide VPN" metric=1
echo "PlayHide is done"
start .\PlayHide.exe