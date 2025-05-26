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
    # Download and install Arduino CLI
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
else
    echo "Arduino CLI found."
fi

# Initialize Arduino CLI config if not exist
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

# Upload the compiled binary to Arduino device
# Assuming device is connected at /dev/ttyACM0 (Linux) or /dev/cu.usbmodem* (macOS)
echo "Uploading to Arduino..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DEVICE_PORT="/dev/ttyACM0"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DEVICE_PORT=$(ls /dev/cu.usbmodem* | head -n 1)
else
    echo "Unsupported OS. Please upload manually."
    exit 1
fi

arduino-cli upload -p "$DEVICE_PORT" --fqbn arduino:avr:uno .

echo "Done! Your Arduino is programmed."
