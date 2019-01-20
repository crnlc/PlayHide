@echo off
set HOME=.\
set PATH=.\
set KEY_CONFIG=openssl-1.0.0.cnf
set KEY_DIR=..\server

set DH_KEY_SIZE=2048
set KEY_SIZE=4096

set KEY_COUNTRY=DE
set KEY_PROVINCE=SA
set KEY_CITY=VPN-City
set KEY_ORG=PlayHide
set KEY_EMAIL=support@playhide.tk
set KEY_CN=server
set KEY_NAME=server.de
set KEY_OU=clients
set PKCS11_MODULE_PATH=changeme
set PKCS11_PIN=1234
cd %HOME%
openssl req -days 3650 -nodes -new -keyout %KEY_DIR%\server.key -out %KEY_DIR%\server.csr -config %KEY_CONFIG%
openssl ca -days 3650 -out %KEY_DIR%\server.crt -in %KEY_DIR%\server.csr -extensions server -config %KEY_CONFIG%
del /q %KEY_DIR%\*.old
