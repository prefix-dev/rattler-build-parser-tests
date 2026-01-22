# First check whether the backup variables are set.
# The backed up variables are allowed to be set empty.
# Then restore the backup, and unset the backup.

if ($env:CLASSPATH_CONDA_BACKUP -ne $null) {
    $env:CLASSPATH = $env:CLASSPATH_CONDA_BACKUP
    Remove-Item Env:CLASSPATH_CONDA_BACKUP
}