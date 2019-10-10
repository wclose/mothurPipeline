#! /bin/bash
# mothurSplitShared.sh
# William L. Close
# Schloss Lab
# University of Michigan

##################
# Set Script Env #
##################

# Set the variables to be used in this script
export MOCKGROUPS=${1:?ERROR: Need to define MOCKGROUPS.} # List of mock groups in raw data dir separated by '-'
export CONTROLGROUPS=${2:?ERROR: Need to define CONTROLGROUPS.} # List of control groups in raw data dir separated by '-'

# Other variables
export OUTDIR=data/mothur/process/
export COMBINEDGROUPS=$(echo "${MOCKGROUPS}"-"${CONTROLGROUPS}") # Combines the list of mock and control groups into a single string separated by '-'



####################################
# Make Group-Specific Shared Files #
####################################

# Sample shared file
echo PROGRESS: Creating sample shared file.

# Removing all mock and control groups from shared file leaving only samples
mothur "#remove.groups(shared="${OUTDIR}"/final.shared, groups="${COMBINEDGROUPS}")"

# Renaming output file
mv "${OUTDIR}"/final.0.03.pick.shared "${OUTDIR}"/sample.final.shared



# Mock shared file
echo PROGRESS: Creating mock shared file.

# Removing non-mock groups from shared file
mothur "#get.groups(shared="${OUTDIR}"/final.shared, groups="${MOCKGROUPS}")"

# Renaming output file
mv "${OUTDIR}"/final.0.03.pick.shared "${OUTDIR}"/mock.final.shared



# Control shared file
echo PROGRESS: Creating control shared file.

# Removing any non-control groups from shared file
mothur "#get.groups(shared="${OUTDIR}"/final.shared, groups="${CONTROLGROUPS}")"

# Renaming output file
mv "${OUTDIR}"/final.0.03.pick.shared "${OUTDIR}"/control.final.shared
