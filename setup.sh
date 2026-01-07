#!/bin/bash

# Create and activate virtual environment if it doesn't exist
if [ ! -d "venv310" ]; then
    echo "Creating virtual environment..."
    python -m venv venv310
fi

# Activate virtual environment
source venv310/Scripts/activate

# Install required packages
echo "Installing required packages..."
pip install -r requirements.txt

# Create models
echo "Creating model files..."
python -m backend.create_models

# Start backend
echo "Starting backend server..."
python -m backend.main 