#!/bin/bash

# This script automates the setup for the WorldMem project.
# It stops if any command fails.
set -e

# --- Script starts here ---

echo "➡️  Cloning the WorldMem repository..."
git clone https://github.com/xizaoqu/WorldMem.git
cd WorldMem

echo "🐍  Creating the 'worldmem' conda environment with Python 3.10..."
conda create -n worldmem python=3.10 -y

echo "📦  Installing Python packages from requirements.txt..."
conda run -n worldmem pip install -r requirements.txt

echo "🎬  Installing ffmpeg..."
conda install -n worldmem -c conda-forge ffmpeg=4.3.2 -y

echo ""
echo "✅  Setup complete!"
echo "To activate your new environment, run:"
echo "conda activate worldmem"
echo ""
echo "Then, to run the application, use:"
echo "python app.py"


conda init
conda activate worldmem
cd WorldMem
python app.py
# python ./WorldMem/app.py
# sh ./WorldMem/infer.sh