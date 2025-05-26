#!/bin/bash
set -e

# Variables
REPO_URL="https://github.com/dilip1202/arduino-led-project.git"
PROJECT_DIR="arduino-led-project"
ARDUINO_CLI_BIN="$HOME/.arduino15/bin/arduino-cli"

echo "Cloning repository..."
git clone "$REPO_URL"
cd "$PROJECT_DIR"

echo "Checking for Arduino CLI..."
if ! command -v arduino-cli &> /dev/null; then
    echo "Arduino CLI not found. Installing..."
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
else
    echo "Arduino CLI found."
fi

# Initialize Arduino CLI config if it doesn't exist
if [ ! -f "$HOME/.arduino15/arduino-cli.yaml" ]; then
    echo "Initializing Arduino CLI config..."
    arduino-cli config init
fi

echo "Updating core index..."
arduino-cli core update-index

# Install Arduino AVR core if not installed
if ! arduino-cli core list | grep -q "arduino:avr"; then
    echo "Installing Arduino AVR core..."
    arduino-cli core install arduino:avr
fi

# Compile the sketch/project
echo "Compiling project..."
arduino-cli compile --fqbn arduino:avr:uno .

# Auto-detect port and upload
echo "Detecting Arduino port..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DEVICE_PORT=$(ls /dev/ttyACM* /dev/ttyUSB* 2>/dev/null | head -n 1)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DEVICE_PORT=$(ls /dev/cu.usbmodem* 2>/dev/null | head -n 1)
else
    echo "Unsupported OS. Please upload manually."
    exit 1
fi

if [ -z "$DEVICE_PORT" ]; then
    echo "Arduino not connected or no serial port found."
    exit 1
fi

echo "Found Arduino on $DEVICE_PORT"
echo "Uploading to Arduino..."

arduino-cli upload -p "$DEVICE_PORT" --fqbn arduino:avr:uno .

echo "✅ Done! Your Arduino is programmed."
