# Run All Script for Medical Chatbot
Write-Host "Starting Medical Chatbot Setup..." -ForegroundColor Green

# Remove existing venv if it exists
if (Test-Path "venv310") {
    Write-Host "Removing existing virtual environment..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force venv310
}

# Create new virtual environment with Python 3.10
Write-Host "Creating new virtual environment..." -ForegroundColor Yellow
py -3.10 -m venv venv310

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
.\venv310\Scripts\Activate.ps1

# Upgrade pip and install dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
python -m pip install --upgrade pip
pip install numpy==1.23.5
pip install -r requirements.txt
pip install "jax[cpu]==0.4.30" jaxlib==0.4.30

# Install frontend dependencies
Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
cd frontend
npm install
cd ..

# Start backend server in a new window
Write-Host "Starting backend server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; .\venv310\Scripts\Activate.ps1; cd backend; python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

# Wait a few seconds for backend to start
Start-Sleep -Seconds 5

# Start frontend in a new window
Write-Host "Starting frontend development server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\frontend'; npm start"

Write-Host "`nSetup complete! Both backend and frontend servers are running." -ForegroundColor Green
Write-Host "Backend: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "`nPress Ctrl+C in each window to stop the servers when done." -ForegroundColor Yellow 