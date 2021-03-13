@echo off
echo "Stop SMB Service"
net stop server /y
echo "Re-Enable SMB Service"
regedit.exe /S .\Enable-SMB.reg

echo "Unblock SMB Service in Windows Firewall"
netsh advfirewall firewall delete rule name="Block_TCP-445"
netsh advfirewall firewall delete rule name="Block_TCP-137"
netsh advfirewall firewall delete rule name="Block_TCP-138"
netsh advfirewall firewall delete rule name="Block_TCP-139"
netsh advfirewall firewall delete rule name="Block_UDP-445"
netsh advfirewall firewall delete rule name="Block_UDP-137"
netsh advfirewall firewall delete rule name="Block_UDP-138"
netsh advfirewall firewall delete rule name="Block_UDP-139"

