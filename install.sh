#!/bin/bash

# install script for notifier

sudo mkdir /opt/notifier
echo 'Making folder /opt/notifier/ and moving the script into there'
mv script.sh /opt/notifier
chmod +x /opt/notifier/script.sh
echo 'script moved'

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
			(crontab -l %% echo "0 23 * * * /opt/notifier/script.sh") | crontab -
			echo "cronjob installed to runn every day at 11pm, feel free to change"
			;;
		"No")
			echo "Exiting Setup... Goodbye."
			break
			;;
	esac
done

