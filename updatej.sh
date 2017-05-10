#!/bin/bash
###Variable
source   ${PWD}/funkcie

declare -A systemdConf

systemdConf[jdownloader]=JDconfig
systemdConf[vnc]=VNCconfig
systemdConf[openbox]=OBoxconfig
systemdConf[xvfb]=Xvfbconfig

url=$(curl http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html 2>&1|grep -o -E 'http://.*arm32.*hflt.tar.gz')

newVersion=$(/bin/echo ${url##*/}|sed -r 's/jdk-8u([0-9]{1,3}).*/\1/g')

inVersion=$(java -version 2>&1|grep version |sed  -r 's/java.*_([0-9]{1,3})./\1/')

dirname=$(/bin/echo ${url##*/}|sed -r 's/jdk-8u([0-9]{1,3}).*/jdk1.8.0_\1/g')

filedir="/home/osmc/"


####


# Abort if not super user
	
	if [[ ! `whoami` = "root" ]]; then
    		/bin/echo "You must have administrative privileges to run this script"
    		/bin/echo "Try 'sudo ./install-java.sh'"
    		exit 1
	fi

### Install or remove JDownloder
#  /bin/echo -e  -n "Would you like to install Jdownloader2 with VNC? [y/N] "
#       confirm=""
#           while [[ $confirm != "n" && $confirm != "N" && $confirm != "y" && $confirm != "Y" ]]; do
#                read confirm
#                      if [[ $confirm = "y" || $confirm = "Y" ]]; then




		 apt-get update && apt-get install openbox x11vnc Xvfb -y	
 		echo -e "heslo\nheslo\n" | x11vnc -storepasswd
 		JDownload
		JDETCconfig
		for i in ${!systemdConf[@]}; do
                "${systemdConf[$i]}"
                done

	if [[ ! -f  /etc/JDownloader2.cfg ]];then
		
		JDETCconfig		
	fi	
	if  [[ -z "${inVersion}" ]]  || [[ "${newVersion}" -gt "${inVersion}" ]] && [[ -z  `pgrep java` ]] ; then
                
		rm  "${filedir}""${url##*/}"*
		/usr/bin/wget -P ${filedir} --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  "${url}"  2>&1 /dev/null
         
			if [[ -f "${filedir}""${url##*/}" ]];then
		
			JAVAinstall
	
			fi
	else
		
		/bin/echo 
		/bin/echo -e  "Installed version Number on system: \e[1;92m"${inVersion}"\e[0m version available on oracle: \e[92m"${newVersion}"\e[39m"
                /bin/echo "Exiting instalation ..." 
		/bin/echo 
	
	fi



       if [[  -f "${filedir}""${url##*/}" ]];then

		rm  "${filedir}""${url##*/}"*

	fi



 #		   fi 
 #done
	exit 0
