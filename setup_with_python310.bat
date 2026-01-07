@echo off
REM Find Python 3.10 executable
where python310 > nul 2>&1
if %errorlevel%==0 (
    set PYTHON_EXE=python310
) else (
    REM Try common install path
    if exist "C:\Python310\python.exe" (
        set PYTHON_EXE=C:\Python310\python.exe
    ) else (
        echo Please install Python 3.10 and ensure it is in your PATH.
        pause
        exit /b 1
    )
)

echo Creating new virtual environment with Python 3.10...
%PYTHON_EXE% -m venv venv310

echo Activating virtual environment...
.\venv310\Scripts\Activate

echo Upgrading pip...
pip install --upgrade pip setuptools wheel

echo Installing dependencies...
pip install -r requirements.txt

echo Running setup script...
python setup.py

echo Starting the chatbot...
python run.py

pause 