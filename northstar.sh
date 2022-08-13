#!/usr/bin/env bash

RED='\033[0;31m'
GRN='\033[0;32m'
RST='\033[0m'

if [ -f "Titanfall2.exe" ]
then
	if [ -f "Titanfall2.exe.vanilla" ]
	then
		STATE="ENABLED"
	elif [ -f "Titanfall2.exe.northstar" ]
	then
		STATE="DISABLED"
	else
		echo -e "${RED}something funny happened here ...${RST}\n if this is the first time using this script make sure to rename the non-active Titanfall executable to either \n${GRN}Titanfall2.exe.vanilla${RST}\n or \n${GRN}Titanfall2.exe.northstar${RST}\n If you do not have Northstar installed just create an empty file called \n${GRN}Titanfall2.exe.northstar${RST}\n and run \n${GRN}./northstar.sh update${RST}\n "
		exit 1
	fi


	case $1 in
		"update")
			VERSION=$(curl --silent "https://api.github.com/repos/R2Northstar/Northstar/releases/latest" | jq ".. .tag_name? // empty" | sed -e 's/^"//' -e 's/"$//')
			wget -c https://github.com/R2Northstar/Northstar/releases/download/$VERSION/Northstar.release.$VERSION.zip
			unzip -o Northstar.release.$VERSION
			case $STATE in
				"DISABLED")
					chmod +x NorthstarLauncher.exe
					cp NorthstarLauncher.exe Titanfall2.exe.northstar
					;;
				"ENABLED")
					cp NorthstarLauncher.exe Titanfall2.exe
					;;
			esac
			;;

		"status")
			echo $([ $STATE == "ENABLED" ] && echo "Northstar is ENABLED" || echo "Northstar is DISABLED")
			;;

		"toggle")
			if [ $STATE == "ENABLED" ]
			then
				echo "restoring Vanilla"
				mv Titanfall2.exe Titanfall2.exe.northstar
				mv Titanfall2.exe.vanilla Titanfall2.exe
			else
				echo "enabling Northstar"
				mv Titanfall2.exe Titanfall2.exe.vanilla
				mv Titanfall2.exe.northstar Titanfall2.exe
			fi
			;;

		*)
			echo -e "usage: \nupdate - to pull latest version\nstatus - to see whether Northstar is currently enabled\ntoggle - to toggle northstar\n"
			;;
	esac
else
	echo -e "${RED}Titanfall2 not found${RST}, please make sure you run this script in your Titanfall2 installation directory"
fi
