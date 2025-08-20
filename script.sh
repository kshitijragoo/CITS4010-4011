#!/bin/bash

# This script automates the setup for your CITS4010-4011 project,
# which includes the WorldMem submodule.
# It will stop if any command fails.
set -e

# --- Script starts here ---

echo "➡️  Cloning your CITS4010-4011 project repository..."
# Note: If the repo is already cloned, you might want to delete it first
# or this script will fail.
git clone https://github.com/kshitijragoo/CITS4010-4011.git
cd CITS4010-4011

echo "🔄  Initializing and updating submodules (this will pull in WorldMem)..."
git submodule update --init --recursive

# Navigate into the WorldMem directory to access its files
cd worldmem

echo "🐍  Creating the 'worldmem' conda environment with Python 3.10..."
conda create -n worldmem python=3.10 -y

echo "📦  Installing Python packages from requirements.txt..."
# Use conda run to execute pip within the correct environment
conda run -n worldmem pip install -r requirements.txt

echo "🎬  Installing ffmpeg into the environment..."
conda install -n worldmem -c conda-forge ffmpeg=4.3.2 -y

echo ""
echo "✅  Setup complete!"
echo "Your project is in the 'CITS4010-4011' directory."
echo ""
echo "To run the application, first navigate to the correct folder and activate the environment:"
echo "cd CITS4010-4011/worldmem"
echo "conda activate worldmem"
echo ""
echo "Then, you can run the application:"
echo "python app.py"
