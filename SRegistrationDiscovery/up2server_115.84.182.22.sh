#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


echo "${red}copy to server 115.84.182.22${reset}"
sshpass -p "ictssh#@!@#$%^&*()" scp -P22015  -r release/vhes-discovery.tar.gz ictssh@115.84.182.22:~/deploy/
echo "${green} finish...<<<${reset}"


