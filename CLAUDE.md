# Garmin Watch Face (Enduro 3)

A minimal digital watch face for the Garmin Enduro 3, built with Monkey C and the Connect IQ SDK.

## Project Structure

```
source/
├── Garmin-FaceApp.mc         # App entry point (Garmin_FaceApp class)
└── Garmin-FaceView.mc        # Watch face rendering (Garmin_FaceView class)
resources/
├── layouts/layout.xml        # UI layout (centered TimeLabel)
├── strings/strings.xml       # Localized strings
└── drawables/                # Icons (launcher_icon.svg)
manifest.xml                  # App metadata, device targets, permissions
monkey.jungle                 # Build config
watch.sh                      # Dev build-watch script (fswatch + auto-deploy)
```

## Tech Stack

- **Language:** Monkey C (Garmin Connect IQ)
- **SDK:** Connect IQ SDK 8.4.1
- **Target Device:** Garmin Enduro 3 (280x280 round display)
- **Min API:** 5.2.0
- **App Type:** watchface

## Architecture

- `Garmin_FaceApp` extends `Application.AppBase` — creates the initial view on launch
- `Garmin_FaceView` extends `WatchUi.WatchFace` — renders time via `onUpdate(dc)`
- Layout loaded from XML resources; time displayed as blue centered text (`Graphics.FONT_LARGE`)
- Resources auto-generate the `Rez` module in `gen/` (resource IDs, layout functions, device constants)

## Build & Development

**Prerequisites:** Garmin Connect IQ SDK, Java runtime, `fswatch` (for watch mode), developer key at `~/.garmin/developer_key.der`

**Watch mode (auto-rebuild + simulator deploy):**
```bash
./watch.sh
```

**Manual build:**
```bash
SDK="/Users/henry/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.1-2026-02-03-e9f77eeaa/bin"
java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true \
    -jar "$SDK/monkeybrains.jar" \
    -o GarminFace.prg \
    -f monkey.jungle \
    -y ~/.garmin/developer_key.der \
    -d enduro3 -w
```

**Deploy to simulator:**
```bash
"$SDK/monkeydo" GarminFace.prg enduro3
```

## Conventions

- Filenames use hyphens (`Garmin-FaceApp.mc`), class names use underscores (`Garmin_FaceApp`)
- Resource IDs use camelCase (`TimeLabel`, `AppName`)
- Files in `gen/` and `mir/` are auto-generated — never edit manually
- The compiled output is `GarminFace.prg`
