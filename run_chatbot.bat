@echo off
echo Starting Medical Chatbot...

:: Activate virtual environment
call venv310\Scripts\activate.bat

:: Start backend server in a new window
start cmd /k "echo Starting Backend Server... && python run.py"

:: Wait for backend to start
timeout /t 5

:: Start frontend in a new window
start cmd /k "echo Starting Frontend... && cd frontend && npm start"

echo Medical Chatbot is starting...
echo Backend will be available at http://localhost:8090
echo Frontend will be available at http://localhost:3000
echo.
echo Press Ctrl+C in each window to stop the servers 