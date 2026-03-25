#!/bin/bash
SDK="/Users/henry/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.1-2026-02-03-e9f77eeaa/bin"
PROJECT="/Users/henry/Code/garmin-face"
KEY="/Users/henry/.garmin/developer_key.der"
DEVICE="enduro3"

build() {
    echo "🔄 Building..."
    java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true \
        -jar "$SDK/monkeybrains.jar" \
        -o "$PROJECT/GarminFace.prg" \
        -f "$PROJECT/monkey.jungle" \
        -y "$KEY" \
        -d "$DEVICE" -w

    if [ $? -eq 0 ]; then
        echo "✅ Build successful, pushing to simulator..."
        "$SDK/monkeydo" "$PROJECT/GarminFace.prg" "$DEVICE" &
    else
        echo "❌ Build failed"
    fi
}

build
echo "Watching for changes..."
fswatch -o "$PROJECT/source" "$PROJECT/resources" | while read; do
    build
done
