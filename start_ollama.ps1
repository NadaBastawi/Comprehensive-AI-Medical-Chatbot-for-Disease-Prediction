# Script to manage Ollama service
Write-Host "Managing Ollama service..." -ForegroundColor Green

# Function to check if Ollama is running
function Test-OllamaRunning {
    $process = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
    return $null -ne $process
}

# Function to check if port 11434 is in use
function Test-PortInUse {
    $listener = Get-NetTCPConnection -LocalPort 11434 -ErrorAction SilentlyContinue
    return $null -ne $listener
}

# Stop Ollama if it's running
if (Test-OllamaRunning) {
    Write-Host "Stopping existing Ollama process..." -ForegroundColor Yellow
    Stop-Process -Name "ollama" -Force
    Start-Sleep -Seconds 2
}

# Check if port is still in use
if (Test-PortInUse) {
    Write-Host "Port 11434 is still in use. Attempting to free it..." -ForegroundColor Yellow
    $process = Get-NetTCPConnection -LocalPort 11434 | Select-Object -ExpandProperty OwningProcess
    if ($process) {
        Stop-Process -Id $process -Force
        Start-Sleep -Seconds 2
    }
}

# Start Ollama
Write-Host "Starting Ollama service..." -ForegroundColor Green
Start-Process -FilePath "ollama" -ArgumentList "serve" -NoNewWindow

# Wait for Ollama to start
$maxAttempts = 10
$attempt = 0
while ($attempt -lt $maxAttempts) {
    if (Test-OllamaRunning) {
        Write-Host "Ollama service started successfully!" -ForegroundColor Green
        break
    }
    Start-Sleep -Seconds 1
    $attempt++
}

if ($attempt -eq $maxAttempts) {
    Write-Host "Failed to start Ollama service. Please check the installation." -ForegroundColor Red
    exit 1
}

Write-Host "Ollama service is ready!" -ForegroundColor Green 