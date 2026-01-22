@echo on

cd test
if errorlevel 1 exit 1

mkdssp.exe --output-format dssp 1cbs.cif.gz 1cbs-cif.dssp
if errorlevel 1 exit 1

findstr /C:"CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II" 1cbs-cif.dssp >nul
if errorlevel 1 exit 1

type 1cbs-cif.dssp
if errorlevel 1 exit 1
