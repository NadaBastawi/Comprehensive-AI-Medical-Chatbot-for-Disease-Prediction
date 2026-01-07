# PowerShell script to install Tesseract OCR for Windows
# This script downloads and installs Tesseract OCR from the UB Mannheim repository

# Define the download URL and installer name
$tesseractUrl = "https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-v5.0.0.20211201.exe"
$installerPath = "$env:TEMP\tesseract-installer.exe"

Write-Host "Medical Signal Processing Chatbot - Tesseract OCR Installer" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will download and install Tesseract OCR for Windows."
Write-Host "Tesseract OCR is required for the lab result image processing feature."
Write-Host ""

# Function to check if Tesseract is already installed
function Test-TesseractInstalled {
    $tesseractPath = "C:\Program Files\Tesseract-OCR\tesseract.exe"
    $tesseractPath86 = "C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"
    
    if (Test-Path $tesseractPath -PathType Leaf) {
        return $true, $tesseractPath
    }
    elseif (Test-Path $tesseractPath86 -PathType Leaf) {
        return $true, $tesseractPath86
    }
    else {
        return $false, $null
    }
}

# Check if Tesseract is already installed
$installed, $path = Test-TesseractInstalled
if ($installed) {
    Write-Host "Tesseract OCR is already installed at: $path" -ForegroundColor Green
    Write-Host "No need to install again."
    Write-Host ""
    Write-Host "If you are having issues with OCR, please make sure to restart the backend server."
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 0
}

# Ask for confirmation to proceed
Write-Host "This will download approximately 25MB and install Tesseract OCR."
$confirmation = Read-Host "Do you want to continue? (y/n)"
if ($confirmation -ne "y") {
    Write-Host "Installation cancelled."
    exit 0
}

# Download the installer
Write-Host "Downloading Tesseract OCR installer..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $tesseractUrl -OutFile $installerPath
    Write-Host "Download completed successfully." -ForegroundColor Green
}
catch {
    Write-Host "Failed to download Tesseract OCR installer: $_" -ForegroundColor Red
    Write-Host "Please download and install Tesseract OCR manually from:"
    Write-Host "https://github.com/UB-Mannheim/tesseract/wiki" -ForegroundColor Cyan
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

# Run the installer
Write-Host "Running Tesseract OCR installer..." -ForegroundColor Yellow
Write-Host "Please follow the installation prompts and use the default settings."
Write-Host "IMPORTANT: Make sure to install in the default location (C:\Program Files\Tesseract-OCR)"
Write-Host ""

try {
    Start-Process -FilePath $installerPath -Wait
    
    # Check if installation was successful
    $installed, $path = Test-TesseractInstalled
    if ($installed) {
        Write-Host "Tesseract OCR was successfully installed at: $path" -ForegroundColor Green
        Write-Host "OCR functionality should now work properly."
        Write-Host ""
        Write-Host "IMPORTANT: Please restart the backend server (python run.py) to apply changes."
    }
    else {
        Write-Host "Tesseract OCR installation may not have completed successfully." -ForegroundColor Yellow
        Write-Host "Please check if it was installed correctly."
    }
}
catch {
    Write-Host "Failed to run Tesseract OCR installer: $_" -ForegroundColor Red
}

# Clean up
if (Test-Path $installerPath) {
    Remove-Item $installerPath
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Check if Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install Tesseract OCR
Write-Host "Installing Tesseract OCR..."
choco install tesseract -y

# Add Tesseract to PATH if not already present
$tesseractPath = "C:\Program Files\Tesseract-OCR"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$tesseractPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$tesseractPath", "User")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "Tesseract OCR installation completed!" 