#!/bin/bash

# Check for root/sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo" 
   exit 1
fi

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl git wget software-properties-common

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_23.2.0 | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn
sudo npm install -g yarn

# Download and install GitKraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb -O gitkraken.deb
sudo dpkg -i gitkraken.deb
sudo apt install -f -y
rm gitkraken.deb

# Clone GitCracken repository
git clone https://github.com/zyclove/GitCracken-crack-code.git
cd GitCracken-crack-code

# Install dependencies and patch
yarn install
yarn build
yarn gitcracken patcher

# Block GitKraken release domain
if [ $? -eq 0 ]; then
    echo "0.0.0.0 release.gitkraken.com" | sudo tee -a /etc/hosts
    echo "Successfully installed development tools and blocked GitKraken domain"
else
    echo "GitCracken patcher failed"
    exit 1
fi