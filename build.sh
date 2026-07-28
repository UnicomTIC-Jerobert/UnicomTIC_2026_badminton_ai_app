#!/bin/bash

# 1. Download the latest stable Flutter SDK
echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable

# 2. Add flutter to the system PATH so Vercel can run flutter commands
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable web support (just in case)
flutter config --enable-web

# 4. Get dependencies and build the web app
echo "Building Flutter Web App..."
flutter pub get
flutter build web --release

echo "Build Completed!"