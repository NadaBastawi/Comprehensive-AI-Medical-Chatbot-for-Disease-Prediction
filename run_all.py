import os
import subprocess
import sys
import time
from pathlib import Path
import shutil

def run_command(command, cwd=None, check=True):
    """Run a command and print its output"""
    print(f"\nRunning: {command}")
    try:
        process = subprocess.run(
            command,
            shell=True,
            cwd=cwd,
            check=check,
            text=True,
            capture_output=True
        )
        print(process.stdout)
        if process.stderr:
            print("Errors:", process.stderr)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        return False

def setup_environment():
    """Set up the Python environment"""
    print("\nSetting up Python environment...")
    
    # Get the Python executable path
    python_path = sys.executable
    
    # Upgrade pip
    run_command(f"{python_path} -m pip install --upgrade pip")
    
    # Install requirements
    run_command(f"{python_path} -m pip install -r requirements.txt")
    
    # Install additional dependencies
    run_command(f"{python_path} -m pip install streamlit")
    run_command(f"{python_path} -m pip install faiss-cpu")
    run_command(f"{python_path} -m pip install sentence-transformers")
    run_command(f"{python_path} -m pip install transformers")
    run_command(f"{python_path} -m pip install torch")

def setup_tensorflow():
    """Set up TensorFlow"""
    print("\nSetting up TensorFlow...")
    run_command("python setup_tensorflow.py")

def setup_components():
    """Set up all chatbot components"""
    print("\nSetting up chatbot components...")
    run_command("python backend/unified_setup.py")

def start_services():
    """Start all required services"""
    print("\nStarting services...")
    
    # Get base directory
    base_dir = Path(__file__).parent
    
    # Start Ollama in the background
    print("\nStarting Ollama...")
    ollama_process = subprocess.Popen(
        "ollama run llama2",
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    time.sleep(5)  # Wait for Ollama to start
    
    # Start the backend server
    print("\nStarting backend server...")
    backend_process = subprocess.Popen(
        "python -m backend.main",
        shell=True,
        cwd=base_dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    time.sleep(5)  # Wait for backend to start
    
    # Start the frontend
    print("\nStarting frontend...")
    frontend_process = subprocess.Popen(
        "streamlit run Chatbot/ui_app.py",
        shell=True,
        cwd=base_dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    return ollama_process, backend_process, frontend_process

def run_all():
    """Run the complete setup and start all services"""
    print("Starting complete setup and running all services...")
    
    try:
        # Step 1: Set up environment
        setup_environment()
        
        # Step 2: Set up TensorFlow
        setup_tensorflow()
        
        # Step 3: Set up components
        setup_components()
        
        # Step 4: Start services
        processes = start_services()
        
        print("\nAll services are running!")
        print("\nYou can access:")
        print("- Frontend: http://localhost:8501")
        print("- Backend API: http://localhost:8000")
        print("\nPress Ctrl+C to stop all services")
        
        # Keep the script running
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\nShutting down services...")
        for process in processes:
            process.terminate()
        print("All services stopped")
    except Exception as e:
        print(f"\nError: {e}")
        print("Attempting to clean up...")
        for process in processes:
            process.terminate()
        sys.exit(1)

if __name__ == "__main__":
    run_all() 