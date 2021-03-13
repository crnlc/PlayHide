
# PlayHide VPN
Build with Autoit & host in EU

PlayHide VPN is an open source alternative to VPN tunnel services like Hamachi and Tunngle. It enables you to play LAN games online with your firends. 

### Client
![Screenshot](https://github.com/DoM1niC/PlayHide/blob/master/res/client.png?raw=true)

### Network Browser / Scanner
![Screenshot](https://github.com/DoM1niC/PlayHide/raw/master/res/network-scanner.png?raw=true)
## Why PlayHide?
- No ads
- No logging
- No spyware
- No account or registration required 
- Automatic updates
- One click to connect
- No port forwarding needed (as client)
- Switch between other servers / locations
- DNS hostname support with domain suffix (.vpn)
- Completely open source including OpenVPN

## Features
- Play your games in LAN mode with your friends
- Share files over LAN
- Host your games, webservers and other services over a VPN*
- Create your own private VPN server and network

_*Only Client to Client / no Traffic Gateway_

Note: _PlayHide does not enable you to play pirated games online. It only enables you to play your games in LAN mode over the Internet._

### Planned features
- Messenging / Chats*

_*Planned freatures may or may not be added_

### Supports
- Windows 7 / 8 / 8.1 / 10 +
- Linux (beta build)



## Installation
1. Download and extract PlayHide in your desired directory
2. Run PlayHide.exe as admin and install 
3. Setup will now install the Tap network driver and create a shortcut on your desktop*
4. Open PlayHide and click *Connect* to join a VPN network
   - You can choose your desired server in the servers menu
   - You can see all connected clients in the network menu

_*PlayHide needs the Tap network driver, otherwise it will not work_



### Running PlayHide as a server
#### Server:
1. Open up Settings.ini and change _ServerMode=0_ to _1_
2. Forward port 1400 as UDP in your router*
    - You can change the port in the Settings.ini
    - Make sure your firewall and anti virus are not blocking the port
3. Start PlayHide
    - The Server is now running. Keep in mind: you don't need to run a client on this machine to be in the VPN since you *are* the VPN

Notes: You might want to set up a DynDNS if you don't want to change the IP address in the clients  with every IP change. 

#### Client: 
1. Open up server_custom.ini_example
2. Configure it with your Domain/DynDNS/IP and port
    - If you are running your own OpenVPN certificates, make sure to add them in the config  
3. Copy your configuration into the server.ini
4. Start PlayHide, select your Server and hit *Connect*

*_Also make sure you have a public ip address and not a private. You can only forward ports on public addresses. To check if you have a public ip address, please refer to this post: https://www.geeksforgeeks.org/difference-between-private-and-public-ip-addresses/_ 

## Deinstalling PlayHide
1. Open up your PlayHide directory
2. Navigate to /driver and your corresponding Windows version
3. Run _Uninstall_Adapter.cmd_ as administrator
    - If you blocked SMB, go to /tools and run Unblock_SMB.cmd as admin.
4. Delete everything else

## Having Issues?
- Make sure your 3rd party firewall get access to Port 1400 as UDP
- The metric must be 1 on the Tap interface. This is normally set by the installer script
- Having multiple network interfaces installed can create driver issues. Please check your device manager for issues, if you don's see the PlayHide VPN adapter under network adapters
- Make sure only one ethernet & no other VPN client are running (Metric conflict)
- The connection limit per server currently is 254 clients
- Other issues? - Contact me on Discord

## Known Issues
- Linux client install and run script is not formatted in the right way
- Linux client uses tap3 as the standard interface. It does not look if its available or look for other interfaces
- Having multiple VPN interfaces seem to create driver issues. Disabling other VPN network interfaces in the device manager fixes that
- The Tap driver uninstaller seems to fail sometimes. Make sure you run it as administrator. If this does not work, deinstall the driver from the device manager


## ![Changelog](Changelog.md)

## Contact
#### Discord: https://discord.gg/zrZ5ynF
#### Matrix: https://matrix.to/#/!SOURRwFRWskoKWLiTQ:matrix.3dns.eu?via=matrix.3dns.eu


##### You like PlayHide? Spend me a Beer 🍺 https://liberapay.com/dom1nic/
