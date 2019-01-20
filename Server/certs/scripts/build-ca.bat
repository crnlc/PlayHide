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
rem build a cert authority valid for ten years, starting now
openssl req -days 3650 -nodes -new -x509 -keyout %KEY_DIR%\ca.key -out %KEY_DIR%\ca.crt -config %KEY_CONFIG%
