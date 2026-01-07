import os
import sys
import subprocess
import time
import signal
import atexit
from pathlib import Path

def check_dependencies():
    """Check if all required dependencies are installed."""
    try:
        import numpy
        import pandas
        import torch
        import transformers
        import streamlit
        import fastapi
        import uvicorn
        import spacy
        import nltk
        print("✓ All Python dependencies are installed")
    except ImportError as e:
        print(f"✗ Missing dependency: {e}")
        print("Please run setup_chatbot.ps1 first")
        sys.exit(1)

def check_model_files():
    """Check if all required model files exist."""
    required_files = [
        "model/best_model.pt",
        "model/label_map.json",
        "model/disease_index.faiss",
        "model/disease_metadata.json",
        "model/disease_chunks.json"
    ]
    
    missing_files = []
    for file in required_files:
        if not os.path.exists(file):
            missing_files.append(file)
    
    if missing_files:
        print("✗ Missing model files:")
        for file in missing_files:
            print(f"  - {file}")
        print("Please ensure all model files are in the correct location")
        sys.exit(1)
    print("✓ All model files are present")

def start_backend():
    """Start the FastAPI backend server."""
    print("Starting backend server...")
    python_executable = os.path.join("venv", "Scripts", "python.exe")
    backend_process = subprocess.Popen(
        [python_executable, "-m", "uvicorn", "--app-dir", ".", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,  # Redirect stderr to stdout to capture all output
        text=True, # Decode as text
        bufsize=1 # Line-buffered output
    )
    for line in iter(backend_process.stdout.readline, ''):
        print(f"[BACKEND] {line.strip()}")
    time.sleep(2)  # Wait for server to start
    return backend_process

def start_frontend():
    """Start the Streamlit frontend."""
    print("Starting frontend...")
    python_executable = os.path.join("venv", "Scripts", "python.exe")
    frontend_process = subprocess.Popen(
        [python_executable, "-m", "streamlit", "run", "Chatbot/ui_app.py"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,  # Redirect stderr to stdout to capture all output
        text=True, # Decode as text
        bufsize=1 # Line-buffered output
    )
    for line in iter(frontend_process.stdout.readline, ''):
        print(f"[FRONTEND] {line.strip()}")
    time.sleep(2)  # Wait for frontend to start
    return frontend_process

def cleanup(processes):
    """Cleanup function to terminate all processes."""
    print("\nShutting down services...")
    for process in processes:
        if process:
            process.terminate()
            process.wait()

def main():
    print("Starting Medical Chatbot...")
    
    # Explicitly activate virtual environment
    venv_python = os.path.join("venv", "Scripts", "python.exe")
    if not os.path.exists(venv_python):
        print(f"Error: Virtual environment Python executable not found at {venv_python}")
        print("Please ensure the virtual environment is set up correctly by running setup_chatbot.ps1 as an administrator.")
        sys.exit(1)
    
    # Use the virtual environment's python for subsequent commands
    python_executable = os.path.join("venv", "Scripts", "python.exe")

    # Check dependencies and model files
    check_dependencies()
    check_model_files()
    
    # Start services
    processes = []
    try:
        backend_process = start_backend()
        processes.append(backend_process)
        
        frontend_process = start_frontend()
        processes.append(frontend_process)
        
        # Register cleanup function
        atexit.register(cleanup, processes)
        
        print("\n✓ Medical Chatbot is running!")
        print("Frontend: http://localhost:8501")
        print("Backend: http://localhost:8000")
        print("\nPress Ctrl+C to stop all services")
        
        # Keep the script running
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\nReceived shutdown signal")
    finally:
        cleanup(processes)

if __name__ == "__main__":
    main() 