#!/bin/bash

# install script for notifier

#checking if mailutils is installed to send mail
REQUIRED_PKG = "mailutils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo "Checking for required dep:\n $REQUIRED_PKG: $PKG_OK"
if [ "" = "$PKG_OK"]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install -y $REUQIRED_PKG
fi

echo 'required deps installed'

#setting up folder structure

sudo mkdir /opt/notifier
echo 'Making folder /opt/notifier/ and moving the script into there'
sudo mv script.sh /opt/notifier
chmod +x /opt/notifier/script.sh
echo 'Script moved'

# ask user for notification address
read -p "What is the notification email address?: " email_address
sed -i "s/notify_email/$email_address/" /opt/notifier/script.sh

echo 'email address changed.'

# will install a cron job to run the script

PS3="Do yo want to install a cronjob? (1/2): "
options=("Yes" "No")
select opt in "${options[@]}"
do 
	case $opt in
		"Yes")
			echo "setting up crontab now..."
			(crontab -l 2>/dev/null; echo "0 23 * * * /opt/notifier/script.sh") | crontab -
			echo "cronjob installed to runn every day at 11pm, feel free to change"
			break
			;;
		"No")
			echo "Exiting Setup... Goodbye."
			break
			;;
	esac
done

