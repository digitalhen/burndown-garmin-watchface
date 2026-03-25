# Burndown

A body battery watch face for circular Garmin watches, built with Monkey C and the Connect IQ SDK.

## Features

- Body battery visualization — grid of colored squares fills the circular display (green = current, red = used)
- Square size scales with daily body battery high
- Date and time with outlined text for readability
- Adapts to any circular screen size

## Supported Devices

- Enduro 3
- Fenix 7 / 7S / 7X (+ Pro variants)
- Fenix 8 Solar (47mm, 51mm), Fenix 8 AMOLED (47mm, 51mm), Fenix E
- Tactix 8 / Tactix 8 AMOLED
- Descent Mk3 / Descent 3i
- MARQ Gen 2 / MARQ Aviator Gen 2
- Forerunner 170 / 265 / 265S / 965
- Epix 2 (+ Pro 42/47/51mm)
- Venu 3 / 3S
- Instinct 3 AMOLED (45mm, 50mm)

## Build

Requires the [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) and a developer key.

```bash
# Auto-rebuild + simulator deploy on file changes
./watch.sh

# Or build manually (replace enduro3 with your device)
SDK="/path/to/connectiq-sdk/bin"
java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true \
    -jar "$SDK/monkeybrains.jar" \
    -o GarminFace.prg \
    -f monkey.jungle \
    -y ~/.garmin/developer_key.der \
    -d enduro3 -w
```

## Adding Devices

Add a `<iq:product id="devicename"/>` entry to the `<iq:products>` block in `manifest.xml`. The watch face adapts to any circular screen size automatically.
