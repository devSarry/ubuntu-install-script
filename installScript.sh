#!/bin/bash
clear

# Create a secure tmp directory
tmp=${TMPDIR-/tmp}
	tmp=$tmp/oduso.$RANDOM.$RANDOM.$RANDOM.$$ # Use a random name so it's secure
	(umask 077 && mkdir "$tmp") || { # Another security precaution
		echo "Could not create temporary directory! Exiting." 1>&2 
		exit 1
	}

if [ $(tput colors) ]; then # Checks if terminal supports colors
	red="\e[31m"
	green="\e[32m"
	endcolor="\e[39m"
fi

distro=$(lsb_release -c | cut -f2)
targetDistro=xenial
if [ "$distro" != "$targetDistro" ]; then
  echo "Wrong Distribution!"
  echo "You are using $distro, this script was made for $targetDistro."
  exit 1
fi

echo --------------------------------------------------------------------------------
echo "We are not responsible for any damages that may possibly occur while using this
echo --------------------------------------------------------------------------------
echo "   "

#use sudo rights for the whole script
sudo -s <<ODUSO

clear

echo ----------------------------------
echo "Welcome to the install script."
echo "Please get some coffee because"
echo "this can take a while"
echo ----------------------------------
echo "   "
sleep 2

trap "rm -rf $tmp" EXIT # Delete tmp files on exit

# Add all the repositories
echo "Adding Repositories" 
(
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-add-repository ppa:transmissionbt/ppa -y
apt-add-repository ppa:nathandyer/vocal-stable -y
apt-add-repository ppa:webupd8team/sublime-text-3 -y
add-apt-repository ppa:webupd8team/java -y
add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
apt-add-repository ppa:atareao/atareao -y
apt-add-repository ppa:apandada1/typhoon -y
apt-add-repository ppa:apandada1/up-clock -y
apt-add-repository ppa:synapse-core/testing -y
apt-add-repository ppa:snwh/pulp -y
apt-get install tlp tlp-rdw
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Updating System" 
(
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Chrome"
(
apt-get install google-chrome-stable -y


) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Vocal"
(
apt-get -y install vocal
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Firefox"
(
apt-get -y install firefox
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Tweaks"
(
apt-get -y install unity-tweak-tool gnome-tweak-tool
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Skype"
(
apt-get install skype
)

echo "Installing Development tools"

	echo "Python stuff"
	(
	sudo apt-get -y install python-pip python-dev python-virtualenv libpq-dev postgresql postgresql-contrib
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

	echo "Virtulization stuff"
	(
	sudo apt-get -y install git virtualbox vagrant
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

	echo "Installing Sublime 3"
	(
	apt-get -y install sublime-text-installer
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output



	echo "Installing Java"
	(
	apt-get -y purge openjdk*
	apt-get -y install oracle-java8-installer
	apt-get -y install oracle-java8-set-default
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

	echo "Installing PyCharm"
	(
	wget https://download.jetbrains.com/python/pycharm-professional-2016.1.2.tar.gz -O $tmp/pycharm.tar.gz
	tar xvf $tmp/pycharm*.tar.gz -d $tmp
	mv $tmp/pycharm* ~/opt/pycharm
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

	echo "Installing PhpStorm"
	(
	wget https://download.jetbrains.com/webide/PhpStorm-2016.1.tar.gz -O $tmp/phpstorm.tar.gz
	tar xvf $tmp/phpstorm*.tar.gz -d $tmp
	mv $tmp/pycharm* ~/opt/phpstorm
	) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output


echo "Installing Synapse"
(
apt-get install synapse -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Up-Clock"
(
apt-get install up-clock -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Transmission"
(
apt-get -y install transmission
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Typhoon"
(
apt-get install typhoon -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output


echo "Installing Flattr"
(
wget https://github.com/NitruxSA/flattr-icons/archive/master.zip -O $tmp/flattr.zip
unzip $tmp/flattr.zip -d $tmp
cd $tmp/luv-icon-theme-master
mv Lüv /usr/share/icons
mv Lüv\ Dark /usr/share/icons
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing file archiving resources"
(
apt-get install unace rar unrar p7zip-rar p7zip zip unzip sharutils uudeview mpack arj cabextract file-roller -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Cleaning up"
(
apt-get -y autoclean 
apt-get -y clean
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Ubuntu Restricted Extra"
(
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections 
apt-get install ttf-mscorefonts-installer -y 
apt-get install ubuntu-restricted-addons -y 
apt-get install gstreamer0.10-plugins-bad-multiverse -y 
apt-get install libavcodec-extra-53 -y 
apt-get install unrar -y
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Upgrading old packages"
(
apt-get -y upgrade
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output

echo "Installing Paper"
(
apt-get install paper-gtk-theme
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output


echo "Installing TLP for better battery life"
(
apt-get install tlp tlp-rdw
tlp start
) &> /dev/null && echo -e "$green OK $endcolor" || echo -e "$red FAILED $endcolor"; # Hide all output


echo "Rebooting in 10 Seconds, CTRL + C to cancel!"
sleep 10
shutdown -r now


ODUSO
notify-send "Oduso" "Finished installing"
exit 0
