@echo off
:: First check whether the backup variables are set.
:: The backed up variables are allowed to be set empty.
:: Then restore the backup, and unset the backup.

if defined CLASSPATH_CONDA_BACKUP (
    set CLASSPATH=%CLASSPATH_CONDA_BACKUP%
    set CLASSPATH_CONDA_BACKUP=
)