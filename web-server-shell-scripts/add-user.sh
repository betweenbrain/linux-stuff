#!/bin/bash

echo "Enter new user's username"
read NEWUSER

useradd -s /bin/bash -m -d /home/$NEWUSER --user-group $NEWUSER
passwd

