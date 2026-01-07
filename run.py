import os
import sys
import platform
import subprocess
import shutil
import importlib.util
import uvicorn
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def main():
    """Main entry point for running the API server."""
    # Get configuration from environment variables
    host = os.getenv("API_HOST", "127.0.0.1")
    port = int(os.getenv("API_PORT", "8090"))
    
    # Start the server
    uvicorn.run(
        "backend.main:app",
        host=host,
        port=port,
        reload=True,
        log_level="info"
    )
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 