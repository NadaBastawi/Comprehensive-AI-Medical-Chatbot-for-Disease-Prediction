# Start Medical Chatbot System
Write-Host "Starting Medical Chatbot System..." -ForegroundColor Green

# Activate Python virtual environment
Write-Host "Activating Python virtual environment..." -ForegroundColor Yellow
& .\venv310\Scripts\Activate.ps1

# Start backend server in a new window
Write-Host "Starting Backend Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {cd '$PWD'; .\venv310\Scripts\Activate.ps1; python run.py}"

# Wait for backend to start
Write-Host "Waiting for backend server to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Start frontend in a new window
Write-Host "Starting Frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {cd '$PWD\frontend'; npm start}"

Write-Host "`nMedical Chatbot is starting..." -ForegroundColor Green
Write-Host "Backend will be available at http://localhost:8090" -ForegroundColor Cyan
Write-Host "Frontend will be available at http://localhost:3000" -ForegroundColor Cyan
Write-Host "`nPress Ctrl+C in each window to stop the servers" -ForegroundColor Yellow 