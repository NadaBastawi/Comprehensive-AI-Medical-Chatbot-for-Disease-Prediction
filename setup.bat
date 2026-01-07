@echo off

REM Create and activate virtual environment if it doesn't exist
if not exist venv310 (
    echo Creating virtual environment...
    python -m venv venv310
)

REM Activate virtual environment
call venv310\Scripts\activate.bat

REM Install required packages
echo Installing required packages...
pip install -r requirements.txt

REM Create models
echo Creating model files...
python -m backend.create_models

REM Start backend
echo Starting backend server...
python -m backend.main 