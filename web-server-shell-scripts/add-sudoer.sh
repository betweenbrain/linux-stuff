#!/bin/bash

echo "Enter new sudoer username"
read SUDOER

sudo cp /etc/sudoers /etc/sudoers.tmp
sudo chmod 0640 /etc/sudoers.tmp
echo "$SUDOER   ALL=(ALL) ALL" >> /etc/sudoers.tmp
sudo chmod 0440 /etc/sudoers.tmp
sudo mv /etc/sudoers.tmp /etc/sudoers

echo "$SUDOER is now a sudoer"

