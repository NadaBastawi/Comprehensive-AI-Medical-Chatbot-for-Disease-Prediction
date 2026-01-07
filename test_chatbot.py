import requests
import json

def test_chatbot():
    """Test the medical chatbot API."""
    print("Testing Medical Signal Processing Chatbot API...")
    
    # Define the API endpoint
    url = "http://localhost:8000/chat"
    
    # Test with symptoms text
    payload = {
        "messages": [
            {"role": "user", "content": "I have chest pain and shortness of breath for 3 days."}
        ],
        "patient_data": {
            "lab_results": {
                "glucose": 130,
                "blood_pressure_systolic": 145,
                "blood_pressure_diastolic": 95,
                "ALT": 45,
                "AST": 38,
                "creatinine": 1.1,
                "white_blood_cells": 9.5
            },
            "signals": {
                "heart_rate": 88,
                "respiratory_rate": 18,
                "temperature": 37.2,
                "oxygen_saturation": 97
            },
            "symptoms_text": "I have chest pain and shortness of breath for 3 days."
        }
    }
    
    try:
        response = requests.post(url, json=payload)
        
        # Print response status
        print(f"Status code: {response.status_code}")
        
        if response.status_code == 200:
            # Print the predictions
            data = response.json()
            print("\nReport:")
            print(data["report"])
            
            print("\nPredictions:")
            for pred in data["predictions"]:
                print(f"- {pred['name']} ({pred['probability']*100:.1f}% confidence)")
                print(f"  Summary: {pred['summary']}")
            
            if data["suggested_labs"]:
                print("\nSuggested Labs:")
                for lab in data["suggested_labs"]:
                    print(f"- {lab}")
            
            if data["warnings"]:
                print("\nWarnings:")
                for warning in data["warnings"].values():
                    print(f"- {warning}")
            
            if data["requires_immediate_attention"]:
                print("\n⚠️ URGENT MEDICAL ATTENTION REQUIRED ⚠️")
        else:
            print(f"Error: {response.text}")
    
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to the API: {e}")
        print("Make sure the backend server is running.")

if __name__ == "__main__":
    test_chatbot() 