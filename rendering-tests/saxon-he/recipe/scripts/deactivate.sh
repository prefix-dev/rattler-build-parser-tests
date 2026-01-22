# First check whether the backup variables are set.
# The backed up variables are allowed to be set empty.
# Then restore the backup, and unset the backup.

if [ "${CLASSPATH_CONDA_BACKUP+x}" ] ; then
  export CLASSPATH=$CLASSPATH_CONDA_BACKUP
  unset CLASSPATH_CONDA_BACKUP
fi
