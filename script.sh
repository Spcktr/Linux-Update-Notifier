#!/bin/bash 

# Send an email when package updates are available so that you can manually check you want to update them.

trigger="following";
filename=/tmp/apt-tmp;

apt-get -qq update
(aptitude -q -s full-upgrade -o Aptitude::Delete-Unused=false --assume-yes --target-release `lsb_release -cs`) > $filename 

count=`grep $trigger $filename | wc -l`;
 if [ $count -gt 0 ] then

     # The word $trigger exists $count times in the file $filename, so send email notification.
    (cat $filename) | mail -s "$(uname -n): Pending Security and Software Updates" notify_email
 else

    # The word $trigger doesn't exist in the file $filename, so exit.
    exit 0
 fi
