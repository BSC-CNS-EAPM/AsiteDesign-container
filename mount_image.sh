#!/bin/bash
################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script mounts the edesign Singularity Image"
   echo "Must have installed:"
   echo "   1. docker"
   echo "   2. singularity"
   echo "! This script have to be in the same folder as the dockerfile !"
   echo
   echo "Syntax: ./mount_image.sh [-|h|u|p]"
   echo "options:"
   echo "h     Print this Help."
   echo "u     Username of the pyrosetta acount."
   echo "p     Password of the pyrosetta acount."
   echo
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################
# Get the options
while getopts "h:u:p" option; do
   case $option in
      h) # display Help
        Help
        exit;;
      u) # username
        user="$OPTARG";;
      p) # pass
        pass="$OPTARG";;
      \?) # incorrect option
        echo "Error: Invalid option"
        exit;;
   esac
done

echo "Building docker image"
sudo docker build --build-arg USER=$user --build-arg PASS=$pass -t edesign .

echo "Creating singularity image"
sudo docker save edesign -o edesign.tar
sudo singularity build edesign.sif docker-archive://edesign.tar
