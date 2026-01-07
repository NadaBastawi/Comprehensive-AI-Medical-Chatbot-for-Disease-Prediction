# Medical Signal Processing Chatbot with OCR

A chatbot for medical signal processing and disease prediction, now with OCR capabilities for lab result images.

## Setup Instructions

### Prerequisites

1. Python 3.7+ with pip
2. Node.js and npm for the frontend
3. Tesseract OCR for image processing

### Installing Tesseract OCR (Required for OCR functionality)

#### Windows:
1. Download the installer from UB Mannheim: https://github.com/UB-Mannheim/tesseract/wiki
2. Run the installer and follow the instructions
3. Use the default installation path (C:\Program Files\Tesseract-OCR)
4. Verify the installation by running `tesseract --version` in Command Prompt
5. **IMPORTANT**: After installation, restart the backend server

#### macOS:
1. Install using Homebrew:
   ```
   brew install tesseract
   ```
2. Or using MacPorts:
   ```
   sudo port install tesseract
   ```

#### Linux:
Tesseract is available in most Linux distributions' package managers:
```
sudo apt-get install tesseract-ocr  # Debian/Ubuntu
sudo dnf install tesseract          # Fedora
```

### Running the Application

1. Start the backend server:
   ```
   python run.py
   ```
   This will check for required dependencies and start the server.

2. Start the frontend development server:
   ```
   cd frontend
   npm start
   ```

3. Open your browser to http://localhost:3000

## Features

- Medical chatbot that processes symptom descriptions
- Signal image processing and analysis
- OCR for lab result images - upload your lab results and get automatic analysis
- Disease prediction based on symptoms and lab values

## Testing With Lab Results

1. Upload a lab result image using the "Upload Lab Results" button
2. The system will automatically extract values like:
   - Hemoglobin, Glucose, White Blood Cells, etc.
   - These values will appear in the blue box when detected
3. Enter symptoms or additional information in the text area
4. Click "Analyze" to get a diagnosis based on both your text input AND the lab values

## Troubleshooting OCR

If OCR is not working:

1. Make sure Tesseract OCR is properly installed (see installation instructions above)
2. Ensure the image is clear and contains visible text with lab values
3. Try using a different image format (PNG or JPEG) 
4. Check for error messages in the red error box that appears when OCR fails
5. Restart the backend server after installing Tesseract
6. If OCR still fails, you can manually add lab values by typing them in the text area:
   ```
   I have the following lab results:
   Glucose: 120
   Hemoglobin: 13.5
   White blood cells: 7.2
   ```

## Patient Data Format

The system expects patient data in the following JSON format:

```json
{
  "lab_results": {
    "glucose": 120,
    "hemoglobin": 13.5,
    "white_blood_cells": 7.2,
    // ... other lab results
  },
  "signals": {
    "heart_rate": 80,
    "respiratory_rate": 16,
    "temperature": 37.5,
    // ... other signal measurements
  }
}
```

## Supported Disease Conditions

The system can diagnose multiple conditions including:
- Type 2 Diabetes Mellitus
- Hypertension
- Atrial Fibrillation
- Congestive Heart Failure
- Acute Respiratory Failure
- Acute Kidney Failure
- Pneumonia
- Hypercholesterolemia
- Iron Deficiency Anemia
- Hypothyroidism

## Future Extensions

The system is designed to be extended with:
- EEG signal processing
- ECG analysis
- More sophisticated medical signal processing algorithms
- Additional disease prediction models
- Real-time signal monitoring

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License 