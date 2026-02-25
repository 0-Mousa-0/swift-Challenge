# RoomaAR - Swift Student Challenge Playground

RoomaAR is an AR furniture placement experience designed for Swift Student Challenge style evaluation.
The project is now structured as a **Playground with Swift source files** (`RoomaAR.playground`), not as a `.swiftpm` package folder.

## Project Structure

```text
RoomaAR.playground
├── Contents.swift
├── contents.xcplayground
├── timeline.xctimeline
├── Resources
│   └── README_Models.txt
└── Sources
    ├── AR
    │   ├── ARSessionManager.swift
    │   └── ARViewContainer.swift
    ├── Models
    │   └── FurnitureItem.swift
    ├── UI
    │   ├── ContentView.swift
    │   ├── FurniturePickerView.swift
    │   └── IntroView.swift
    └── Utilities
        └── AppState.swift
```

## Build / Run

1. Open `RoomaAR.playground` in Xcode (or Swift Playgrounds on iPad).
2. Run the playground on a **real iPad** (ARKit is not supported in iOS Simulator for this experience).
3. Grant camera permission when prompted.
4. Move the iPad slowly to scan surfaces, select furniture, then tap to place.

## Swift Student Challenge Alignment Checklist

- Experience can be understood quickly (target: within ~3 minutes).
- Uses only local resources (no network dependency).
- Includes clear English UI guidance for reviewers.
- Keeps 3D assets optimized for smooth real-time AR performance.
- Designed to keep final submission package lightweight.

## Performance Notes

- Preloads and caches models to reduce placement latency.
- Uses AR coaching overlay to stabilize plane detection.
- Trims placed anchors if the scene becomes too heavy.
- Uses procedural fallback geometry if USDZ assets are missing, so the app remains usable during development.

## Asset Setup

Drop your `sofa.usdz`, `table.usdz`, `chair.usdz`, `curtain.usdz`, and `carpet.usdz` files into:

`RoomaAR.playground/Resources/`

For best performance, keep polygon counts and texture sizes low.
