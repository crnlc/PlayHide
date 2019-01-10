chmod 744 ./ -R
LoginTXT="./config/login.txt"
MACTXT="./config/MAC.txt"

if [ ! -f $LoginTXT ];
then
echo "Setup PlayHide VPN"
apt install -y openvpn isc-dhcp-client
touch $LoginTXT
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 >> $LoginTXT
echo -e "" >> $LoginTXT
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 >> $LoginTXT
dhclient -r tap3 &> /dev/null
pkill openvpn &> /dev/null
screen -d -S PlayHide-VPN -m openvpn config/playhide.conf
sleep 3
touch $MACTXT
cat /sys/class/net/tap3/address > $MACTXT
sleep 1
screen -X -S PlayHide-VPN quit
pkill openvpn &> /dev/null
echo "Done! Run Script again!"
else
echo "StartUp PlayHide VPN"
MAC=cat $MACTXT &> /dev/null
screen -X -S PlayHide-VPN quit &> /dev/null
dhclient -r tap3 &> /dev/null
screen -d -S PlayHide-VPN -m openvpn config/playhide.conf --lladdr $MAC
sleep 2
dhclient -v tap3 &> /dev/null
ip addr|awk '/tap3/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print "Your IP is : " $2}'
fi