import subprocess
import sys
import os
from pathlib import Path

def run_command(command):
    """Run a command and print its output"""
    print(f"Running: {command}")
    process = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
    print(process.stdout)
    if process.stderr:
        print("Errors:", process.stderr)

def setup_tensorflow():
    """Set up TensorFlow and verify installation"""
    print("Setting up TensorFlow...")
    
    # Get the Python executable path
    python_path = sys.executable
    
    # Upgrade pip
    run_command(f"{python_path} -m pip install --upgrade pip")
    
    # Install TensorFlow and its dependencies
    run_command(f"{python_path} -m pip install tensorflow==2.15.0")
    run_command(f"{python_path} -m pip install keras==2.15.0")
    
    # Verify installation
    print("\nVerifying TensorFlow installation...")
    verify_script = """
import tensorflow as tf
import keras
print(f"TensorFlow version: {tf.__version__}")
print(f"Keras version: {keras.__version__}")
print("TensorFlow is using GPU:", tf.config.list_physical_devices('GPU'))
    """
    
    # Write verification script to a temporary file
    verify_path = Path("verify_tf.py")
    with open(verify_path, "w") as f:
        f.write(verify_script)
    
    # Run verification
    run_command(f"{python_path} verify_tf.py")
    
    # Clean up
    verify_path.unlink()
    
    print("\nTensorFlow setup completed!")

if __name__ == "__main__":
    setup_tensorflow() 