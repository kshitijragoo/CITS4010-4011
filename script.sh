#!/bin/bash

# This script automates the setup for your CITS4010-4011 project,
# which includes the WorldMem and VGGT submodules.
# It will stop if any command fails.
set -e

# --- Script starts here ---

# This script requires a GitHub Personal Access Token (PAT) to be set in an
# environment variable called GH_TOKEN.
if [ -z "$GH_TOKEN" ]; then
    echo "Error: GH_TOKEN environment variable is not set."
    echo "Please set it to your GitHub Personal Access Token."
    exit 1
fi


echo "🧹 Cleaning up old directory if it exists..."
rm -rf CITS4010-4011

echo "➡️  Cloning your project repository using a Personal Access Token..."
# Inject the token into the clone URL for authentication
git clone "https://oauth2:${GH_TOKEN}@github.com/kshitijragoo/CITS4010-4011.git"
cd CITS4010-4011


echo "🔄  Updating submodule URLs to also use the token..."
# This command finds the submodule URLs and injects the token into them too
sed -i "s|https://github.com/|https://oauth2:${GH_TOKEN}@github.com/|" .gitmodules

echo "🔄  Initializing and updating submodules (this will pull in WorldMem, VGGT, etc.)..."
git submodule update --init --recursive

# Navigate into the WorldMem directory to access its files
cd worldmem


# --- Environment setup ---
echo "🐍 Creating the 'worldmem' mamba environment with Python 3.10 (if not exists)..."
if mamba env list | grep -q "worldmem"; then
    echo "✅ Environment 'worldmem' already exists, skipping creation."
else
    mamba create -n worldmem python=3.10 -y
fi 


echo "📦  Installing WorldMem's Python packages from requirements.txt..."
# Use mamba run to execute pip within the correct environment
mamba run -n worldmem pip install -r requirements.txt


# --- [NEW SECTION] INSTALL VGGT IN EDITABLE MODE ---
echo "⚙️  Setting up the VGGT submodule..."

echo "    -> Navigating to the VGGT directory..."
cd ../vggt  # Go up one level from 'worldmem' and into 'vggt'

echo "    -> Installing VGGT's specific requirements..."
# mamba run -n worldmem pip install -r requirements.txt

echo "    -> Installing VGGT package in editable mode..."
mamba run -n worldmem pip install -e .

# echo "    -> Navigating to the VMEM directory..."
# cd ../vmem  # Go up one level from 'worldmem' and into 'vmem'

# echo "    -> Installing VMEM package in editable mode..."
# mamba run -n worldmem pip install -e .


echo "    -> Returning to the WorldMem directory..."
cd ../worldmem # Go back to the 'worldmem' directory for the rest of the script
# --- END OF NEW SECTION ---


echo "🎬  Installing ffmpeg into the environment..."
mamba install -n worldmem -c conda-forge ffmpeg=4.3.2 -y


echo "🔄  Ensuring we are in the worldmem directory..."
# This cd is now less critical but kept for safety in case of manual script changes
cd /workspace/CITS4010-4011/worldmem


echo "🐍  Activating the 'worldmem' environment..."
eval "$(mamba shell hook --shell bash)"
mamba activate worldmem


echo ""
echo "✅  Setup complete!"
echo "Your project is in the 'CITS4010-4011' directory."
echo ""
echo "To run the application, first navigate to the correct folder and activate the environment:"
echo "cd CITS4010-4011/worldmem"
echo "mamba activate worldmem"
echo ""
echo "Then, you can run the application:"
echo "python app.py"