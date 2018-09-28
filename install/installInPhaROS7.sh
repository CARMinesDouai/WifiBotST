#!/usr/bin/env bash

# This script creates a PhaROS Image in a specified directory
# @author: Luc Fabresse

# Constants =========================

ROS_DISTRO=kinetic

CATKIN_PACKAGE_NAME=wifibot

INSTALLDIR=$(rospack find $CATKIN_PACKAGE_NAME)

PHARO_RPACKAGE_NAME=WifibotPackage

PHARO_VM_URL="http://get.pharo.org/64/vm70"
PHARO_IMAGE_URL="http://get.pharo.org/64/70"

PHARO_VM="$INSTALLDIR/vm/pharo --nodisplay "
PHAROS_IMAGE="$INSTALLDIR/image/PhaROS.image"
PHAROS_NODE_IMAGE="$INSTALLDIR/image/$CATKIN_PACKAGE_NAME.image"


# Script specific ===================

# stop the script if a single command fails
set -e

COLOR="\e[1;93m"
WHITE="\e[0;37m"

QUIET=">/dev/null 2>&1"

PRINT() {
	echo -e "\n${COLOR}$@${WHITE}"
}




#  try to use curl if possible
if [[ `which curl 2> /dev/null` ]]; then
	DOWNLOAD="curl --silent --location --compressed ";
	DOWNLOAD_TO="$DOWNLOAD --output ";
elif [[ `which wget 2> /dev/null` ]]; then
	DOWNLOAD_TO="wget --quiet --output-document=";
	DOWNLOAD="$DOWNLOAD_TO-";
else
	# PRINT "Please install curl or wget on your machine:\n\tsudo apt-get install curl\n\n";
	sudo apt-get install curl
	# exit 1
fi


# ~/PhaROS directory ================

if [ ! -d $INSTALLDIR ]; then
	mkdir $INSTALLDIR
fi



cd $INSTALLDIR


# Pharo VM ==========================

if [ ! -d "$INSTALLDIR/vm" ]; then
	PRINT "Downloading Pharo VM in $INSTALLDIR/vm"
	mkdir $INSTALLDIR/vm
	cd $INSTALLDIR/vm
	$DOWNLOAD "$PHARO_VM_URL" | bash
	rm pharo pharo-ui
	mv pharo-vm/* .
	rmdir pharo-vm
	cd ..
else
	PRINT "[ALREADY EXISTS] $INSTALLDIR/vm"
fi

# image directory ================

if [ ! -d "$INSTALLDIR/image" ]; then
	mkdir "$INSTALLDIR/image"
fi


# PhaROS.image =======================

if [ -f $PHAROS_NODE_IMAGE ]; then
	PRINT "[ALREADY EXISTS] $PHAROS_NODE_IMAGE"
	exit
fi

cd "$INSTALLDIR/image"	
	
if [ ! -f $PHAROS_IMAGE ]; then
	PRINT "Downloading $PHARO_IMAGE_URL"
	$DOWNLOAD "$PHARO_IMAGE_URL" | bash 
	$PHARO_VM Pharo.image save PhaROS --delete-old	
	
	if [[ a$http_proxy != "a" ]]; then 
		# get proxy info from environment variable http_proxy e.g. http://10.1.1.3:8080
		PROXYSERVER=`echo $http_proxy | cut -d\/ -f3 | cut -d: -f1`
		PROXYPORT=`echo $http_proxy | cut -d\/ -f3 | cut -d: -f2`
		PRINT "Set HTTP proxy (${PROXYSERVER}:${PROXYPORT}) in $INSTALLDIR/pharos.image"
		$PHARO_VM PhaROS.image eval --save "NetworkSystemSettings useHTTPProxy: true; httpProxyServer: '${PROXYSERVER}'; httpProxyPort: ${PROXYPORT}."
	fi
		
	PRINT "Load PhaROS in $PHAROS_IMAGE"
	$PHARO_VM $PHAROS_IMAGE config http://smalltalkhub.com/mc/CAR/PhaROS/main ConfigurationOfPhaROS --install=bleedingEdge
fi
	
# The Pharo image for this catkin package ======================

#PRINT "Need work to be done ;-) because of TaskIT branch in MC" && exit -1


if [ ! -f $PHAROS_NODE_IMAGE ]; then

	PRINT "Create $PHAROS_NODE_IMAGE"
	$PHARO_VM $PHAROS_IMAGE save $CATKIN_PACKAGE_NAME 
	$PHARO_VM $PHAROS_NODE_IMAGE eval --save "Author fullName: 'pharos'. #PhaROSCatkinDeployer asClass setupImageForCurrentCatkinPackage. #$PHARO_RPACKAGE_NAME asClass  removeFromSystem. (RPackage named: '$PHARO_RPACKAGE_NAME') unregister.  '$INSTALLDIR/Pharo/WifiBotST-Legacy.st' asFileReference fileIn. '$INSTALLDIR/Pharo/WifiBotST.st' asFileReference fileIn. '$INSTALLDIR/Pharo/$PHARO_RPACKAGE_NAME.st' asFileReference fileIn " 

fi

