import uvicorn

if __name__ == "__main__":
    print("Starting Medical Signal Processing Chatbot API...")
    uvicorn.run("backend.main:app", host="0.0.0.0", port=8000) 