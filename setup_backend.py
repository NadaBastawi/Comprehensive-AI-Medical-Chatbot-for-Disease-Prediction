import os
import sys
import subprocess
from pathlib import Path

def run_command(command):
    """Run a command and print its output"""
    print(f"Running: {command}")
    process = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
    print(process.stdout)
    if process.stderr:
        print("Errors:", process.stderr)

def setup_backend():
    """Set up all backend requirements"""
    print("Setting up backend...")
    
    # Install Python dependencies
    print("\nInstalling Python dependencies...")
    run_command("pip install -r requirements.txt")
    
    # Install Tesseract OCR
    print("\nInstalling Tesseract OCR...")
    run_command("python install_tesseract.py")
    
    # Set up models
    print("\nSetting up models...")
    run_command("python backend/setup_models.py")
    
    print("\nBackend setup completed!")
    print("\nTo start the backend server, run:")
    print("python -m backend.main")

if __name__ == "__main__":
    setup_backend() 