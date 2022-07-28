#!/bin/bash

PATH_TO_SO_LONG="../../so_long_retry_2"
PATH_TO_MAPS="tester_maps/errors"


SEPARATOR="--------------------------------------------------------------------------------------"
bold=$(tput bold)
regular=$(tput sgr0)
red="\033[31m"
green="\033[32m"
default_color="\033[0m"

clear

for file in `ls $PATH_TO_MAPS`
do
	echo $SEPARATOR
	echo ""
	#Print filename
	echo -e "${bold}${file^^}${regular}"
	echo ""

	#Print map
	cat	$PATH_TO_MAPS/$file
	echo -e "${red}"
	
	#Launch test and get pid of the process
	$PATH_TO_SO_LONG/so_long $PATH_TO_MAPS/$file 1>/dev/null 2>output & pid=($!)
	
	#Kill so_long if error case is not handled
	if [ `ps -p $pid | wc -l` -gt 1 ]
	then
  		kill -SIGKILL $pid 
		wait $pid 2>/dev/null
	fi
	sleep .5
	
	echo -en "\033[m"
	
	#Print error message
	if [ `cat output | grep -c "Error"` -eq 1 ]
	then
		echo -e "${bold}${green}OK${default_color}${regular}"
		echo ""
		cat output
	else
		echo -e "${bold}${red}KO${default_color}${regular}"
	fi
	echo ""
	rm output
done

echo $SEPARATOR
