#!/bin/bash

if [ "$EUID" -ne 0 ]
then
echo "Please run as root to copy the application folder and files to /usr/share and /usr/bin"
exit
fi

desktopFile="demo.desktop"
desktopFilePath="./application/$desktopFile"


for user in $(cut -d: -f1 /etc/passwd); do
    if [ -d "/home/$user" ]; then
        cp "$desktopFilePath" "/home/$user/.config/autostart/"
        chown $user:$user "/home/$user/.config/autostart/$desktopFile"
    fi
done

mv "$desktopFilePath" /usr/share/applications/

mv ./application/demo /usr/bin/
mkdir ActionsDemo
mv -v ./application/* ./ActionsDemo
rm -d application
chmod a+rx ActionsDemo/
rm -r /usr/share/ActionsDemo/
mv ./ActionsDemo /usr/share/




