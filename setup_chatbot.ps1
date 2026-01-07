# Comprehensive setup script for the medical chatbot
Write-Host "Starting comprehensive setup for Medical Chatbot..." -ForegroundColor Green

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Set venv Python path
$venvPython = Join-Path $PWD 'venv\Scripts\python.exe'
$venvPip = Join-Path $PWD 'venv\Scripts\pip.exe'

# Function to install Python package
function Install-PythonPackage {
    param($package)
    $maxRetries = 3
    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -lt $maxRetries) {
        Write-Host "Installing $package (Attempt $($retryCount + 1))..." -ForegroundColor Yellow
        & $venvPip install $package
        if ($LASTEXITCODE -eq 0) {
            $success = $true
        } else {
            $retryCount++
            if ($retryCount -lt $maxRetries) {
                Write-Host "Retrying in 5 seconds..." -ForegroundColor Yellow
                Start-Sleep -Seconds 5
            }
        }
    }

    if (-not $success) {
        Write-Host "Failed to install $package after $maxRetries attempts" -ForegroundColor Red
        exit 1
    }
}

# Function to install Node.js package
function Install-NodePackage {
    param($package)
    Write-Host "Installing $package..." -ForegroundColor Yellow
    npm install $package
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install $package" -ForegroundColor Red
        exit 1
    }
}

# Check Python installation
$pythonVersion = & $venvPython --version
if ($pythonVersion -notmatch "Python 3\.(8|9|10|11)") {
    Write-Host "Please install Python 3.8-3.11. Current version: $pythonVersion" -ForegroundColor Red
    Write-Host "You can download it from: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Check Node.js installation
if (-not (Test-Command node)) {
    Write-Host "Node.js is not installed. Please install Node.js." -ForegroundColor Red
    exit 1
}

# Check npm installation
if (-not (Test-Command npm)) {
    Write-Host "npm is not installed. Please install Node.js." -ForegroundColor Red
    exit 1
}

# Create and activate virtual environment
Write-Host "Setting up Python virtual environment..." -ForegroundColor Green
if (Test-Path venv) {
    Remove-Item -Recurse -Force venv
}
python -m venv venv
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create virtual environment. Please ensure you have write permissions." -ForegroundColor Red
    exit 1
}

# Upgrade pip, setuptools, and wheel before anything else
Write-Host "Upgrading pip, setuptools, and wheel in the virtual environment..." -ForegroundColor Green
& $venvPython -m pip install --upgrade pip setuptools wheel
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to upgrade pip, setuptools, or wheel" -ForegroundColor Red
    exit 1
}

# Activate virtual environment
$env:VIRTUAL_ENV = "$PWD\venv"
$env:PATH = "$env:VIRTUAL_ENV\Scripts;$env:PATH"
$env:PYTHONHOME = $null

# Install Python dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Green
$venvPython = Join-Path $PWD 'venv\Scripts\python.exe'
$venvPip = Join-Path $PWD 'venv\Scripts\pip.exe'

# List of packages with latest compatible versions for Python 3.11
$pythonPackages = @(
    "numpy>=1.26.0",
    "pandas>=2.1.0",
    "scikit-learn>=1.3.0",
    "transformers>=4.35.0",
    "faiss-cpu>=1.7.4",
    "streamlit>=1.28.0",
    "fastapi>=0.104.1",
    "uvicorn>=0.24.0",
    "python-multipart>=0.0.6",
    "opencv-python-headless>=4.8.1.78",
    "scipy>=1.11.3",
    "matplotlib>=3.8.0",
    "seaborn>=0.13.0",
    "wfdb>=4.1.2",
    "requests>=2.31.0",
    "python-dotenv>=1.0.0",
    "pydantic>=2.4.2",
    "joblib>=1.3.2",
    "pillow>=10.1.0",
    "tqdm>=4.66.1",
    "nltk>=3.8.1",
    "spacy>=3.7.2",
    "beautifulsoup4>=4.12.2",
    "lxml>=4.9.3",
    "h5py>=3.10.0"
)

# Install all packages except torch
Write-Host "Installing main Python packages..." -ForegroundColor Green
& $venvPython -m pip install @pythonPackages
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install main Python packages" -ForegroundColor Red
    exit 1
}

# Install torch separately with its index URL
Write-Host "Installing torch (CPU version) from PyTorch index..." -ForegroundColor Green
& $venvPython -m pip install torch==2.7.1+cpu --index-url https://download.pytorch.org/whl/cpu
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install torch" -ForegroundColor Red
    exit 1
}

# Install spaCy language model
Write-Host "Installing spaCy language model..." -ForegroundColor Green
& $venvPython -m spacy download en_core_web_sm

# Install Node.js dependencies
Write-Host "Installing Node.js dependencies..." -ForegroundColor Green
$nodePackages = @(
    "express",
    "socket.io",
    "cors",
    "body-parser",
    "axios",
    "dotenv",
    "react@17.0.2",
    "react-dom@17.0.2",
    "react-scripts@5.0.1",
    "@material-ui/core@4.12.4",
    "@material-ui/icons@4.11.3",
    "styled-components@5.3.10"
)

foreach ($package in $nodePackages) {
    Install-NodePackage $package
}

# Check for Ollama installation and install if not present
Write-Host "Checking for Ollama installation..." -ForegroundColor Green
if (-not (Test-Command ollama)) {
    Write-Host "Ollama is not installed. Installing Ollama..." -ForegroundColor Yellow
    # Download and install Ollama for Windows
    $ollamaUrl = "https://ollama.com/download/windows"
    $ollamaInstaller = "ollama-setup.exe"
    Invoke-WebRequest -Uri $ollamaUrl -OutFile $ollamaInstaller
    Start-Process -FilePath $ollamaInstaller -ArgumentList "/SILENT" -Wait
    Remove-Item $ollamaInstaller
    Write-Host "Ollama installed. Please restart your terminal or system if 'ollama' command is not found." -ForegroundColor Yellow
} else {
    Write-Host "Ollama is already installed." -ForegroundColor Green
}

# Start Ollama service using our management script
Write-Host "Starting Ollama service..." -ForegroundColor Green
powershell.exe -File ".\start_ollama.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start Ollama service. Please check the installation." -ForegroundColor Red
    exit 1
}

# Pull the specified Ollama model (llama3.2)
Write-Host "Pulling Ollama model: llama3.2..." -ForegroundColor Green
ollama pull llama3.2
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to pull llama3.2 model. Please ensure Ollama is running and accessible." -ForegroundColor Red
    exit 1
} else {
    Write-Host "llama3.2 model pulled successfully." -ForegroundColor Green
}

# Check for Tesseract OCR
if (-not (Test-Command tesseract)) {
    Write-Host "Tesseract OCR is not installed. Installing..." -ForegroundColor Yellow
    # Download and install Tesseract
    $tesseractUrl = "https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20230401.exe"
    $tesseractInstaller = "tesseract-installer.exe"
    Invoke-WebRequest -Uri $tesseractUrl -OutFile $tesseractInstaller
    Start-Process -FilePath $tesseractInstaller -ArgumentList "/S" -Wait
    Remove-Item $tesseractInstaller
}

# Create necessary directories
Write-Host "Creating necessary directories..." -ForegroundColor Green
$directories = @(
    "model",
    "models",
    "temp",
    "backend",
    "frontend",
    "Chatbot"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir
    }
}

# Copy model files if they exist
Write-Host "Setting up model files..." -ForegroundColor Green
$modelFiles = @(
    "best_model.pt",
    "label_map.json",
    "disease_index.faiss",
    "disease_metadata.json",
    "disease_chunks.json"
)

foreach ($file in $modelFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "model/$file" -Force
    }
}

# Run setup scripts
Write-Host "Running setup scripts..." -ForegroundColor Green
& $venvPython backend/unified_setup.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in unified setup" -ForegroundColor Red
    exit 1
}

# Create frontend directory structure
Write-Host "Setting up frontend structure..." -ForegroundColor Green
$frontendDirs = @(
    "frontend/src",
    "frontend/public",
    "frontend/src/components",
    "frontend/src/assets"
)

foreach ($dir in $frontendDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
    }
}

# Create basic frontend files
$frontendFiles = @{
    "frontend/public/index.html" = @"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Medical Chatbot</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
"@
    "frontend/src/index.js" = @"
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
"@
    "frontend/src/App.js" = @"
import React, { useState } from 'react';
import ChatInterface from './components/ChatInterface';
import './App.css';

function App() {
  return (
    <div className="App">
      <ChatInterface />
    </div>
  );
}

export default App;
"@
    "frontend/src/components/ChatInterface.js" = @"
import React, { useState, useEffect } from 'react';
import { Container, Paper, TextField, Button, Typography } from '@material-ui/core';
import styled from 'styled-components';

const ChatContainer = styled(Container)`
  margin-top: 2rem;
  height: 80vh;
  display: flex;
  flex-direction: column;
`;

const MessageArea = styled(Paper)`
  flex-grow: 1;
  margin-bottom: 1rem;
  padding: 1rem;
  overflow-y: auto;
`;

const InputArea = styled.div`
  display: flex;
  gap: 1rem;
`;

function ChatInterface() {
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');

  const handleSend = async () => {
    if (!input.trim()) return;

    const userMessage = { text: input, sender: 'user' };
    setMessages(prev => [...prev, userMessage]);
    setInput('');

    try {
      const response = await fetch('http://localhost:8000/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: input })
      });
      const data = await response.json();
      setMessages(prev => [...prev, { text: data.response, sender: 'bot' }]);
    } catch (error) {
      console.error('Error:', error);
      setMessages(prev => [...prev, { text: 'Sorry, I encountered an error.', sender: 'bot' }]);
    }
  };

  return (
    <ChatContainer maxWidth="md">
      <Typography variant="h4" gutterBottom>
        Medical Chatbot
      </Typography>
      <MessageArea>
        {messages.map((msg, idx) => (
          <div key={idx} style={{ textAlign: msg.sender === 'user' ? 'right' : 'left' }}>
            <Paper style={{ 
              display: 'inline-block', 
              padding: '0.5rem 1rem',
              margin: '0.5rem',
              backgroundColor: msg.sender === 'user' ? '#e3f2fd' : '#f5f5f5'
            }}>
              {msg.text}
            </Paper>
          </div>
        ))}
      </MessageArea>
      <InputArea>
        <TextField
          fullWidth
          variant="outlined"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          placeholder="Type your message..."
        />
        <Button 
          variant="contained" 
          color="primary" 
          onClick={handleSend}
        >
          Send
        </Button>
      </InputArea>
    </ChatContainer>
  );
}

export default ChatInterface;
"@
}

foreach ($file in $frontendFiles.Keys) {
    if (-not (Test-Path $file)) {
        Set-Content -Path $file -Value $frontendFiles[$file]
    }
}

# Initialize frontend
Write-Host "Initializing frontend..." -ForegroundColor Green
Set-Location frontend
npm init -y
foreach ($package in $nodePackages) {
    Install-NodePackage $package
}
Set-Location ..

# Create backend API
Write-Host "Setting up backend API..." -ForegroundColor Green
$backendFiles = @{
    "backend/app.py" = @"
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
import ollama

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatMessage(BaseModel):
    message: str

@app.post("/chat")
async def chat(message: ChatMessage):
    try:
        response = ollama.chat(model='llama2', messages=[
            {
                'role': 'user',
                'content': message.message
            }
        ])
        return {"response": response['message']['content']}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
"@
}

foreach ($file in $backendFiles.Keys) {
    if (-not (Test-Path $file)) {
        Set-Content -Path $file -Value $backendFiles[$file]
    }
}

# Start services
Write-Host "Starting services..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm start"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; python app.py"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "ollama serve"

Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host "Frontend is running at http://localhost:3000" -ForegroundColor Green
Write-Host "Backend API is running at http://localhost:8000" -ForegroundColor Green 