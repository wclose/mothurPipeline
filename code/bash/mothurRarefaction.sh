#! /bin/bash
# mothurRarefaction.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export SHARED=${1:?ERROR: Need to define SHARED}



###########################
# Make Rarefaction Curves #
###########################

# Generating rarefaction files
echo PROGRESS: Generating rarefaction tables.

# Calculating rarefaction curve data
mothur "#rarefaction.single(shared="${SHARED}", calc=sobs, freq=100)"

# Cleaning up rabund files
rm $(find $(echo "${SHARED}" | sed 's/\(.*\/\).*/\1/') -regex ".*final\..*\.rabund")
