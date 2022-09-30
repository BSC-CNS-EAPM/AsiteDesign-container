#!/bin/bash
################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo -e "\nThis script mounts the AsiteDesign Singularity Image"
   echo "Must have installed:"
   echo "   1. docker"
   echo "   2. singularity"
   echo -e "\n! This script have to be in the same folder as the dockerfile !\n"
   echo "Syntax: ./mount_image.sh [-|h|u|p]"
   echo "options:"
   echo "-h     Print this Help."
   echo
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################
# Get the options
while getopts "h" option; do
   case $option in
      h) # display Help
        Help
        exit;;
   esac
done
# Get user and password
read -p "User: " user
read -s -p "Password: " pass

echo -e "\n################# Building docker image #################\n"
sudo docker build --build-arg USER=$user --build-arg PASS=$pass -t asitedesign:latest .

echo -e "\n################# Creating singularity image #################\n"
sudo singularity build asitedesign.sif docker-daemon://asitedesign:latest
