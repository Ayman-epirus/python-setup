:: this batch (.bat) file is intended to help with checking if a python
:: version is install, and creating a virtual enviroment with the name "venv". If a 
:: requirement.txt file exists in the directory, packages will be installed and pip 
:: will be updated. 
:: usage: 
:: key arguments: 
:: python_version i.e --> python3.9.13
:: venv_name i.e --> name of enviorment , default to "venv"
:: include_dependencies i.e --> y to install requirements.txt, n to not -default is 1

@::!/dos/rocks
@echo off
goto :init

:header
    echo %__NAME% v%__VERSION%
    echo STATUS  : python setup pipeline initializing ... 
    goto :eof

:usage
    echo USAGE:
    echo   %__BAT_NAME% [flags] "python version" "virtual enviroment name" 
    echo   %__BAT_Name% --y python3.9.13
    echo.
    echo.  /?, --help                   help :)
    echo.  /v, --version                script version
    echo.  /e, --description            shows detailed output
    echo.  -f, --include_dependencies   y or n to install requirements.txt
    goto :eof

:version
    if "%~1"=="full" call :header & goto :eof
    echo %__VERSION%
    goto :eof

:missing_argument
    echo ERROR : missing required argument 'python_version' i.e python3.9.13
    call :usage
    goto :eof

:init
    set "__NAME=%~n0"
    set "__VERSION=0.0.1"
    set "__YEAR=2023"

    set "__BAT_FILE=%~0"
    set "__BAT_PATH=%~dp0"
    set "__BAT_NAME=%~nx0"

    set "OptHelp="
    set "OptVersion="
    set "OptVerbose="

    set "python_version="
    set "venv_name="
    set "include_dependencies="

:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"         call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="-?"         call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="--help"     call :header & call :usage "%~2" & goto :end

    if /i "%~1"=="/v"         call :version      & goto :end
    if /i "%~1"=="-v"         call :version      & goto :end
    if /i "%~1"=="--version"  call :version full & goto :end

    if /i "%~1"=="/e"         set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="-e"         set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="--verbose"  set "OptVerbose=yes"  & shift & goto :parse

    if /i "%~1"=="--flag"     set "include_dependencies=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-f"         set "include_dependencies=%~2"   & shift & shift & goto :parse

    if not defined python_version     set "python_version=%~1"     & shift & goto :parse
    if not defined venv_name  set "venv_name=%~1"  & shift & goto :parse
    if not defined include_dependencies  set "include_dependencies=%~1"  & shift & goto :parse

    shift
    goto :parse

:validate
    if not defined python_version call :missing_argument & goto :end

:main
    call :header
    if defined OptVerbose (
        echo description TODO
    )
    
    echo STATUS  : checking if %python_version% is installed ...
    FOR /F "tokens=*" %%g IN ('python --version') do (SET py_version=%%g)
    echo STATUS  : python version installed is  %py_version% 

    if defined venv_name (
        echo STATUS  : creating python virtual enviorment "%venv_name%"
        python -m venv "%venv_name%
        echo STATUS  : "%venv_name%" python virtual enviorment is created
        call .\"%venv_name%"\Scripts\activate.bat
    )     
    if not defined venv_name (
        echo WARNING : 'venv_name' is not provided, using defalut name 
        echo STATUS  : creating python virtual enviorment venv ...
        python -m venv venv
        echo STATUS  : venv python virtual enviorment is created
        echo STATUS  : activating python virtual enviorment venv ...
        call .\venv\Scripts\activate.bat
    )   

    if defined include_dependencies (   
        echo STATUS  : 'include_dependencies' is "%include_dependencies%"
        if exist requirements.txt (
            echo STATUS  : found a requirements.txt file, installing dependencies ...
            pip install -r requirements.txt
        ) 
        if not exist requirements.txt (
            echo STATUS  : requirements.txt not found, skipping this step
        )
        
    )
    if not defined include_dependencies (
        echo WARNING : 'include_dependencies' not provided, defalut to y
        echo STATUS  : checking if a requirements.txt file exists
        if exist requirements.txt (
            echo STATUS  : found a requirements.txt file, installing dependencies ...
            pip install -r requirements.txt
        ) 
        else (
            echo STATUS  : requirements.txt not found, skipping this step
        )

    )          

:end
    call :cleanup
    exit /B

:cleanup
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.
    set "__NAME="
    set "__VERSION="
    set "__YEAR="

    set "__BAT_FILE="
    set "__BAT_PATH="
    set "__BAT_NAME="

    set "OptHelp="
    set "OptVersion="
    set "OptVerbose="

    set "python_version="
    set "venv_name="
    set "include_dependencies="

    goto :eof