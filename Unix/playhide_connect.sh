LoginTXT="./config/login.txt"
MACTXT="./config/MAC.txt"
MAC=cat $MACTXT &> /dev/null

if [ "$1" = "setup" ];
then
echo "Setup PlayHide VPN"
chmod 744 ./ -R
rm $LoginTXT
apt install -y openvpn isc-dhcp-client
touch $LoginTXT
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 >> $LoginTXT
echo -e "" >> $LoginTXT
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 >> $LoginTXT
dhclient -r tap3 &> /dev/null
pkill -f "openvpn --daemon --config ./config/playhide.conf" &> /dev/null
#openvpn --config ./config/playhide.conf &> /dev/null
#touch $MACTXT
#cat /sys/class/net/tap3/address > $MACTXT
pkill -f "openvpn --config ./config/playhide.conf" &> /dev/null
echo "Done! Run Script again!"
fi

if [ "$1" = "start" ];
then
echo "Start PlayHide VPN"
pkill -f "openvpn --daemon --config ./config/playhide.conf" &> /dev/null
dhclient -r tap3 &> /dev/null
sleep 1
openvpn --daemon --config ./config/playhide.conf &> /dev/null
sleep 2
dhclient -v tap3 &> /dev/null
ip addr|awk '/tap3/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print "Your IP is : " $2}'
fi

if [ "$1" = "status" ];
then
ip addr|awk '/tap3/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print "Your IP is : " $2}'
fi

if [ "$1" = "stop" ];
then
echo "Stop PlayHide VPN"
dhclient -r tap3 &> /dev/null
pkill -f "openvpn --daemon --config ./config/playhide.conf" &> /dev/null
fi