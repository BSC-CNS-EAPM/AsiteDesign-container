#!/bin/bash
################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo -e "\nThis script mounts the edesign Singularity Image"
   echo "Must have installed:"
   echo "   1. docker"
   echo "   2. singularity"
   echo -e "\n! This script have to be in the same folder as the dockerfile !\n"
   echo "Syntax: ./mount_image.sh [-|h|u|p]"
   echo "options:"
   echo "-h     Print this Help."
   echo "-u     Username of the pyrosetta acount."
   echo "-p     Password of the pyrosetta acount."
   echo
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################
if [[ $# -eq 0 ]] ; then
    echo -e "\nError: Invalid option"
    Help
    exit 0
fi
# Get the options
while getopts "h:u:p:" option; do
   case $option in
      h) # display Help
        Help
        exit;;
      u) # username
        user="$OPTARG";;
      p) # pass
        pass="$OPTARG";;
      \?) # incorrect option
        echo -e "\nError: Invalid option"
        Help
        exit 0;;
   esac
done
echo "################# Building docker image #################"
sudo docker build --build-arg USER=$user --build-arg PASS=$pass -t edesign:latest .

echo "################# Creating singularity image #################"
sudo singularity build edesign.sif docker-daemon://edesign:latest
