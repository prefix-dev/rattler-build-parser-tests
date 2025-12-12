powershell -Command "(Get-Content setup.py) -replace 'std:c\+\+17', 'std:c++20' | Set-Content setup.py"

copy numberofcharacters.h src\pdftopng

%PYTHON% setup.py build

%PYTHON% -m pip install . -vv
