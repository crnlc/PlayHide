@echo off
echo "Stop SMB Service"
net stop server /y
echo "Disable SMB Service"
regedit.exe /S .\Disable-SMB.reg

echo "Block SMB Service in Windows Firewall"
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=445 name="Block_TCP-445"
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=137 name="Block_TCP-137"
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=138 name="Block_TCP-138"
netsh advfirewall firewall add rule dir=in action=block protocol=TCP localport=139 name="Block_TCP-139"
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=445 name="Block_UDP-445"
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=137 name="Block_UDP-137"
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=138 name="Block_UDP-138"
netsh advfirewall firewall add rule dir=in action=block protocol=UDP localport=139 name="Block_UDP-139"
