import os
import sys
import subprocess
import platform
import venv
import shutil
from pathlib import Path

def create_venv():
    """Create a Python virtual environment."""
    venv_path = "venv310"
    if not os.path.exists(venv_path):
        print("Creating Python virtual environment...")
        venv.create(venv_path, with_pip=True)
    return venv_path

def install_python_dependencies(venv_path):
    """Install Python dependencies."""
    print("Installing Python dependencies...")
    
    # Determine the pip path based on the OS
    if platform.system() == "Windows":
        pip_path = os.path.join(venv_path, "Scripts", "pip.exe")
    else:
        pip_path = os.path.join(venv_path, "bin", "pip")
    
    # Upgrade pip
    print("Upgrading pip...")
    subprocess.run([pip_path, "install", "--upgrade", "pip"], check=True)
    
    # Install required packages
    requirements = [
        "fastapi==0.109.0",
        "uvicorn==0.27.0",
        "python-multipart==0.0.6",
        "numpy==1.24.3",
        "pandas==2.0.3",
        "scikit-learn==1.6.1",
        "tensorflow==2.15.0",
        "opencv-python==4.8.1.78",
        "pytesseract==0.3.10",
        "python-jose==3.3.0",
        "passlib==1.7.4",
        "bcrypt==4.0.1",
        "python-dotenv==1.0.0",
        "sqlalchemy==1.4.23",
        "pydantic==2.5.3",
        "aiofiles==0.7.0",
        "pillow==10.0.0",
        "scipy==1.10.1",
        "matplotlib==3.8.2",
        "seaborn==0.11.2",
        "langchain==0.1.0",
        "chromadb==0.4.22",
        "sentence-transformers==2.2.2",
        "ollama==0.1.6"
    ]
    
    for req in requirements:
        subprocess.run([pip_path, "install", req], check=True)

def install_node_dependencies():
    """Install Node.js dependencies."""
    print("Installing Node.js dependencies...")
    
    # Check if npm is installed
    try:
        subprocess.run(["npm", "--version"], capture_output=True, check=True)
        print("npm is installed.")
    except FileNotFoundError:
        print("Error: npm (Node.js Package Manager) not found.")
        print("Please install Node.js and npm from https://nodejs.org/en/download/")
        sys.exit(1)
    except subprocess.CalledProcessError:
        print("Error: npm command failed. Please ensure Node.js and npm are properly installed and in your PATH.")
        sys.exit(1)

    # Install frontend dependencies
    os.chdir("frontend")
    subprocess.run(["npm", "install"], check=True)
    
    # Install additional frontend packages
    frontend_packages = [
        "@heroicons/react",
        "@headlessui/react",
        "axios",
        "react-markdown",
        "react-syntax-highlighter",
        "tailwindcss",
        "postcss",
        "autoprefixer",
        "@tailwindcss/forms"
    ]
    
    for package in frontend_packages:
        subprocess.run(["npm", "install", package], check=True)
    
    os.chdir("..")

def setup_ollama():
    """Setup Ollama for RAG."""
    print("Setting up Ollama...")
    
    # Check if Ollama is installed
    try:
        subprocess.run(["ollama", "--version"], capture_output=True, check=True)
        print("Ollama is already installed.")
    except FileNotFoundError:
        print("Please install Ollama from https://ollama.ai")
        sys.exit(1)
    except subprocess.CalledProcessError:
        print("Ollama command failed. Please ensure Ollama is installed and in your PATH.")
        sys.exit(1)
    
    # Pull required models
    models = ["llama2", "mistral"]
    for model in models:
        print(f"Pulling {model} model...")
        subprocess.run(["ollama", "pull", model])

def setup_tesseract():
    """Setup Tesseract OCR."""
    print("Setting up Tesseract OCR...")
    
    if platform.system() == "Windows":
        print("On Windows, Tesseract OCR needs to be installed manually.")
        print("Please download and install from: https://github.com/UB-Mannheim/tesseract/wiki")
        print("Ensure 'Add to PATH' is selected during installation.")
    else:
        print("On Linux/macOS, Tesseract OCR can usually be installed via package manager.")
        print("For Debian/Ubuntu: sudo apt-get install tesseract-ocr")
        print("For macOS (with Homebrew): brew install tesseract")
    
    # Check if Tesseract is in PATH after manual installation instructions
    try:
        subprocess.run(["tesseract", "--version"], capture_output=True, check=True)
        print("Tesseract is in your PATH.")
    except FileNotFoundError:
        print("Warning: Tesseract is not found in your PATH. Please ensure it's installed and added to PATH.")
        sys.exit(1) # Exit if Tesseract is not found, as it's a critical component
    except subprocess.CalledProcessError:
        print("Warning: Tesseract command failed. Please ensure Tesseract OCR is properly installed and in your PATH.")
        sys.exit(1)

def create_environment_file():
    """Create .env file with necessary configurations."""
    print("Creating environment configuration...")
    
    env_content = """
# API Configuration
API_HOST=127.0.0.1
API_PORT=8090

# Database Configuration
DATABASE_URL=sqlite:///medical_chatbot.db

# Ollama Configuration
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama2

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# File Storage
UPLOAD_DIR=uploads
MAX_UPLOAD_SIZE=10485760  # 10MB
"""
    
    with open(".env", "w") as f:
        f.write(env_content)

def create_upload_directories():
    """Create necessary directories for file uploads."""
    print("Creating upload directories...")
    
    directories = [
        "uploads",
        "uploads/lab_results",
        "uploads/signals",
        "uploads/radiology",
        "uploads/temp"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)

def main():
    """Main setup function."""
    print("Starting setup of Medical Chatbot...")
    
    # Create virtual environment
    venv_path = create_venv()
    
    # Install Python dependencies
    install_python_dependencies(venv_path)
    
    # Install Node.js dependencies
    install_node_dependencies()
    
    # Setup Ollama
    setup_ollama()
    
    # Setup Tesseract
    setup_tesseract()
    
    # Create environment file
    create_environment_file()
    
    # Create upload directories
    create_upload_directories()
    
    print("\nSetup completed successfully!")
    print("\nTo start the chatbot:")
    print("1. Start the backend server: python run.py")
    print("2. Start the frontend: cd frontend && npm start")
    print("\nThe chatbot will be available at http://localhost:3000")

if __name__ == "__main__":
    main() 