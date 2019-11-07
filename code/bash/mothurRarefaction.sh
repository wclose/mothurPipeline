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

# Other settings
export OUTDIR=$(echo "${SHARED}" | sed 's:\(.*/\).*:\1:')



###########################
# Make Rarefaction Curves #
###########################

# Generating rarefaction files
echo PROGRESS: Generating rarefaction tables.

# Creating tmp directory for easier clean up and to avoid conflicts with rarefaction rabund files
TMP="${OUTDIR}"/tmp_$(date +%s)/
mkdir -p "${TMP}"/

# Copying shared file to tmp directory so output files will be placed there
cp "${SHARED}" "${TMP}"/

# Finding path to shared file in new location
TMP_SHARED=$(echo "${SHARED}" | sed 's:'"${OUTDIR}"':'"${TMP}"':')

# Calculating rarefaction curve data
mothur "#rarefaction.single(shared="${TMP_SHARED}", calc=sobs, freq=100)"

# Moving output to main output dir
mv "${TMP}"/*groups*rarefaction "${OUTDIR}"

# Cleaning up
rm -rf "${TMP}"/
