#!/usr/bin/php -q
<?php

//Configuration
$ValidUserFile='/etc/openvpn/passwd_gateway'; //This file must be in htpasswd SHA1 format (htpasswd -s)
$Method='via-env'; //via-file or via-env (see auth-user-pass-verify configuration above for more information)

//Get the login info
if($Method=='via-file') //via-file method
{
	$LoginInfoFile=trim(file_get_contents('php://stdin')); //Get the file that contains the passed login info from stdin
	$LoginInfo=file_get_contents($LoginInfoFile); //Get the passed login info
	file_put_contents($LoginInfoFile, str_repeat('x', strlen($LoginInfo))); //Shred the login info file
	$LoginInfo=explode("\n", $LoginInfo); //Split into [Username, Password]
	$UserName=$LoginInfo[0];
	$Password=$LoginInfo[1];
}
else //via-env method
{
	$UserName=$_SERVER['username'];
	$Password=$_SERVER['password'];
}

//Test the login info against the valid user file
$UserLine="$UserName:$Password"; //Compile what the user line should look like
echo $UserLine;
		print "Logged in: $UserName\n";
		exit(0);

//Return failure
print "NOT Logged in: $UserName\n";
exit(1);
?>
