# First backup the variables if they are set.
# The variables are allowed to be empty (Null).
# Then set the variables to the location of this package.
# The deactivate script restores the backed up variables.

# The CLASSPATH is set to the location of the jar files.
$SaxonHE_HOME = "$env:CONDA_PREFIX\Library\lib\SaxonHE"

if ($env:CLASSPATH) {
    $env:CLASSPATH_CONDA_BACKUP = $env:CLASSPATH
} else {
    $env:CLASSPATH = ""
}

$jarFiles = Get-ChildItem -Path "$SaxonHE_HOME\*.jar"
foreach ($jar in $jarFiles) {
    $env:CLASSPATH = "$($jar.FullName);$env:CLASSPATH"
}