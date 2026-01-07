import os
import sys
import subprocess
import requests
import zipfile
import shutil
from pathlib import Path

def download_file(url, filename):
    """Download a file from a URL"""
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(filename, 'wb') as f:
        if total_size == 0:
            f.write(response.content)
        else:
            downloaded = 0
            total_size = int(total_size)
            for data in response.iter_content(chunk_size=4096):
                downloaded += len(data)
                f.write(data)
                done = int(50 * downloaded / total_size)
                sys.stdout.write(f"\r[{'=' * done}{' ' * (50-done)}] {downloaded}/{total_size} bytes")
                sys.stdout.flush()
    print()

def install_tesseract():
    """Install Tesseract OCR"""
    print("Installing Tesseract OCR...")
    
    # Create temp directory
    temp_dir = Path("temp")
    temp_dir.mkdir(exist_ok=True)
    
    # Download Tesseract installer
    installer_url = "https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20230401.exe"
    installer_path = temp_dir / "tesseract-installer.exe"
    
    print("Downloading Tesseract installer...")
    download_file(installer_url, installer_path)
    
    # Install Tesseract
    print("Running installer...")
    subprocess.run([str(installer_path), "/S"], check=True)
    
    # Clean up
    shutil.rmtree(temp_dir)
    
    print("Tesseract OCR installation completed!")
    print("Please make sure to add Tesseract to your system PATH if it's not already there.")

if __name__ == "__main__":
    install_tesseract() 