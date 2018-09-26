#!/usr/bin/env bash

# This script creates a PhaROS Image in a specified directory
# @author: Luc Fabresse

# Constants =========================

ROS_DISTRO=kinetic

INSTALLDIR="$HOME/PhaROS-bin"
PHAROS_WORKSPACE_DIR="$HOME/PhaROS-ws"
PHAROS_TOOL="$HOME/bin/pharos"

PHARO_VM="http://get.pharo.org/64/vm70"
PHARO_IMAGE="http://get.pharo.org/64/70"


# Script specific ===================

# stop the script if a single command fails
set -e

COLOR="\e[1;93m"
WHITE="\e[0;37m"

QUIET=">/dev/null 2>&1"

PRINT() {
	echo -e "\n${COLOR}$@${WHITE}"
}


PRINT "Need work to be done ;-)" && exit -1


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

if [ ! -f $INSTALLDIR/pharo ]; then
	PRINT "Downloading Pharo VM in $INSTALLDIR"
	rm -fr $INSTALLDIR/pharo-vm $INSTALLDIR/pharo $INSTALLDIR/pharo-ui 2>/dev/null
	$DOWNLOAD "$PHARO_VM" | bash
	# curl http://get.pharo.org/vm50 | bash
else
	PRINT "[ALREADY EXISTS] $INSTALLDIR/pharo"
fi

# Mandatory packages for 64bits systems, ... =======================

	
function messageToInstallPackages()
{
	sudo dpkg --add-architecture i386 
	sudo apt-get update 
	sudo apt-get install ${PACKAGES_TO_INSTALL[@]}
}

PACKAGES_TO_INSTALL=("build-essential" "cmake")


if [[ `uname -p` == 'x86_64' ]]; then 	# are we on a 64bits system?
	
	UBUNTU_VERSION=`lsb_release -r`
	echo -e "\n${WHITE}Ubuntu ${UBUNTU_VERSION}"	
	
	if [[ ${UBUNTU_VERSION} == *"16.04"* ]]; then
		PACKAGES_TO_INSTALL=("libx11-6:i386" "libgl1-mesa-glx:i386" "libfontconfig1:i386" "libssl1.0.0:i386")
	else	
		PACKAGES_TO_INSTALL=("lib32z1" "libasound2:i386" "libasound2-plugins:i386" "libssl0.9.8:i386" "libgl1-mesa-glx:i386" "libfreetype6:i386" "ia32-libs")
	fi	
		
	## Run the run_install function if any of the libraries are missing
	dpkg -s "${PACKAGES_TO_INSTALL[@]}" >/dev/null 2>&1 || messageToInstallPackages
fi

# Pharo.image =======================

if [ ! -f $INSTALLDIR/Pharostable.image ]; then
	PRINT "Downloading $INSTALLDIR/Pharo.image"
	rm -f $INSTALLDIR/Pharo.changes 2>/dev/null
	$DOWNLOAD "$PHARO_IMAGE" | bash 
	$INSTALLDIR/pharo Pharo.image save Pharostable --delete-old
else
	PRINT "[ALREADY EXISTS] $INSTALLDIR/Pharo.image"
fi

# pharos.image ======================

if [ ! -f $INSTALLDIR/pharos.image ]; then

	rm -f $INSTALLDIR/pharos.changes 2>/dev/null
	
	PRINT "Create $INSTALLDIR/pharos.image"
	$INSTALLDIR/pharo Pharostable.image save pharos

	if [[ a$http_proxy != "a" ]]; then 
		# get proxy info from environment variable http_proxy e.g. http://10.1.1.3:8080
		PROXYSERVER=`echo $http_proxy | cut -d\/ -f3 | cut -d: -f1`
		PROXYPORT=`echo $http_proxy | cut -d\/ -f3 | cut -d: -f2`
		PRINT "Set HTTP proxy (${PROXYSERVER}:${PROXYPORT}) in $INSTALLDIR/pharos.image"
		$INSTALLDIR/pharo pharos.image eval --save "NetworkSystemSettings useHTTPProxy: true; httpProxyServer: '${PROXYSERVER}'; httpProxyPort: ${PROXYPORT}."
	fi

	PRINT "Load PhaROSCommander in $INSTALLDIR/pharos.image"
	$INSTALLDIR/pharo pharos.image config http://smalltalkhub.com/mc/CAR/PhaROS/main ConfigurationOfPhaROSCommander --install=stable
fi

# pharos command ====================

PHAROS_TOOL_DIR=`dirname $PHAROS_TOOL`
if [ ! -d $PHAROS_TOOL_DIR ]; then
	PRINT "Create $PHAROS_TOOL_DIR"
	mkdir $PHAROS_TOOL_DIR
fi

if [ ! -f $PHAROS_TOOL ]; then
	PRINT "Create $PHAROS_TOOL"
	echo -e "#!/usr/bin/env bash\n#set -f #disable parameter expansion\n$INSTALLDIR/pharo $INSTALLDIR/pharos.image \$@\n" >$PHAROS_TOOL
	chmod +x $PHAROS_TOOL
	
	# pharos-ui 
	PRINT "Create ${PHAROS_TOOL}-ui"
	echo -e "#!/usr/bin/env bash\n#set -f #disable parameter expansion\n$INSTALLDIR/pharo-ui $INSTALLDIR/pharos.image \$@\n" >"$PHAROS_TOOL-ui"
	chmod +x "$PHAROS_TOOL-ui"
fi

# uninstall script for PhaROS
PHAROS_TOOL_UNINSTALL_SCRIPT="$INSTALLDIR/pharos_uninstall"
PRINT "Create ${PHAROS_TOOL}_uninstall"
cat <<END > $PHAROS_TOOL_UNINSTALL_SCRIPT
#!/usr/bin/env bash
grep -iv pharos $HOME/.bashrc > $INSTALLDIR/.bashrc
cp -f $INSTALLDIR/.bashrc $HOME/.bashrc
rm -fr $INSTALLDIR $PHAROS_WORKSPACE_DIR $PHAROS_TOOL ${PHAROS_TOOL}-ui
END

chmod +x $PHAROS_TOOL_UNINSTALL_SCRIPT

# ensures that $HOME/bin is in PATH	or already added in ~/.bashrc
if [[ "$PATH" != *"$PHAROS_TOOL_DIR"* ]] && [[ `cat $HOME/.bashrc | grep $PHAROS_TOOL_DIR` == "" ]]; then 
	echo -e "export PATH=\"$PHAROS_TOOL_DIR:\$PATH\"\n" >> $HOME/.bashrc
fi

# ensures ROS commands ==============

MANDATORY_ROS_COMMANDS="catkin_init_workspace catkin_make"

ROS_COMMAND_TO_INSTALL=""

for roscommand in $MANDATORY_ROS_COMMANDS; do		
	# if $roscommand not in PATH
	if [[ `which $roscommand` == "" ]]; then
			ROS_COMMAND_TO_INSTALL="$ROS_COMMAND_TO_INSTALL $roscommand"
	fi	
done

if [[ $ROS_COMMAND_TO_INSTALL != "" ]]; then
		PRINT "[ERROR] ROS is not correctly set up\nDoes your .bashrc contains:\t\tsource /opt/ros/${ROS_DISTRO}/setup.bash\n\n        Did you source it:\n\n\t\tsource ~/.bashrc\n"
		exit 1
fi

# catkin workspace for PhaROS =======

if [ ! -d $PHAROS_WORKSPACE_DIR ]; then
	
	PRINT "Create PhaROS catkin workspace ($PHAROS_WORKSPACE_DIR)"
	
	mkdir -p $PHAROS_WORKSPACE_DIR/src
	cd $PHAROS_WORKSPACE_DIR/src
	catkin_init_workspace
	
	cd $PHAROS_WORKSPACE_DIR
	catkin_make

	# ensure that PhaROS packages will be found by rosrun
	echo -e "\n# for pharos catkin workspace\n[ -f $PHAROS_WORKSPACE_DIR/devel/setup.sh ] && source $PHAROS_WORKSPACE_DIR/devel/setup.sh --extend\n" >> $HOME/.bashrc
fi

# END ===============================
. $HOME/.bashrc
pharos --help
