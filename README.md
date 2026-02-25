# RoomaAR - Swift/Xcode iOS App

RoomaAR is now structured as a **standard Xcode SwiftUI iOS app** (not playground, not `.swiftpm` package app).

## Project Structure

```text
RoomaAR.xcodeproj
RoomaAR
├── App
│   └── RoomaARApp.swift
├── AR
│   ├── ARSessionManager.swift
│   └── ARViewContainer.swift
├── Assets.xcassets
├── Models
│   └── FurnitureItem.swift
├── Resources
│   └── README_Models.txt
├── Utilities
│   └── AppState.swift
└── Views
    ├── ContentView.swift
    ├── FurniturePickerView.swift
    ├── IntroView.swift
    └── SimulatorRoomView.swift
```

## Run in Xcode Simulator

1. Open `RoomaAR.xcodeproj` in Xcode.
2. Select an iOS Simulator device.
3. Build and Run.
4. App will use **Simulator Mode** (tap on the screen to place furniture cards).

## Run on Real Device (AR mode)

1. Select a real iPhone/iPad.
2. Build and Run.
3. Grant camera permission.
4. Move device to detect surfaces and place furniture in AR.

## Performance Notes

- Model preloading/caching for smoother placement on device.
- AR coaching overlay for stable plane detection.
- Anchor trimming to keep scene responsive.
- Simulator fallback mode for fast UI + interaction testing.
- Procedural fallback entities if USDZ assets are missing.

## Asset Setup

Drop your models into:

`RoomaAR/Resources/`

Expected names:
- `sofa.usdz`
- `table.usdz`
- `chair.usdz`
- `curtain.usdz`
- `carpet.usdz`
