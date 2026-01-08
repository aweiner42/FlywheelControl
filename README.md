# FlywheelControl

[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-blue)](https://swiftpackageindex.com/aweiner42/FlywheelControl)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-blue)](https://swiftpackageindex.com/aweiner42/FlywheelControl)

A tactile, momentum-based radial control for SwiftUI — inspired by analog flywheels.  
![FlywheelControl Logo](Assets/FlywheelIcon.png)

A SwiftUI-based, physics-inspired radial scroller for zooming, scrubbing, and precision value adjustments.  
**FlywheelControl** mimics the feel of a real-world dial — complete with momentum, resistance, haptic feedback, and **pen-friendly input**.

---

## 🌀 Why FlywheelControl?

We needed a more natural way to zoom — something better than pinch and expand.  
So we built a **rotary-style control** that works with a **finger or stylus**, and feels real thanks to physics and CoreHaptics.

---

## ✨ Features

- 🎛️ Inertial spinning like a physical dial  
- 📱 One-finger- and **Apple Pencil-friendly**  
- 💥 Haptic ticks for tactile feedback  
- 🎨 Fully SwiftUI and easy to customize  
- 🧠 Binding-driven: tracks a zoom `position` with clamped min/max offsets and live span adjustments
- 🚀 Smooth momentum decay and natural stopping behavior  
- 🎨 Custom skin support: Apply your own ruler artwork for a fully branded experience  
- 🛑 Clamp limits: minValue and maxValue must be > 0
- 📏 spanCM defines visible range (must be > 0)
- 🔓 Optional clamping: turn off min/max limits for free spinning in auto modes

---

## 📦 Installation

### Swift Package Manager

**In Xcode:**

1. Go to `File → Add Packages…`  
2. Enter the URL: `https://github.com/aweiner42/FlywheelControl`  
3. Choose the latest version (e.g., `1.2.4`)

**Or add it to your `Package.swift`:**

```swift
.package(url: "https://github.com/aweiner42/FlywheelControl.git", from: "1.2.4")
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["FlywheelControl"]
)
```

Import the module where needed:

```swift
import FlywheelControl
```

### 🖼 Adding a Custom Skin

Place your ruler artwork (e.g., `RulerSkin.png`) in your app’s Asset Catalog (`Assets.xcassets`) and assign it the name `RulerSkin`. FlywheelControl will automatically load this image if present.

The package includes a sample ruler skin (`DefaultRuler.png`). You can copy it into your app’s Asset Catalog and rename it `RulerSkin` for immediate use.

When using Swift Playgrounds, FlywheelControl automatically falls back to its bundled reference skin unless a custom track image is explicitly provided.

---

## 🧪 Explore on iPad with Swift Playgrounds (No Xcode)

FlywheelControl can be explored interactively on an iPad using **Swift Playgrounds** — no Xcode required.
This is intended as a lightweight **DX front door** so engineers can feel inertia and tuning before integrating the SDK into an app.

### Requirements
- Swift Playgrounds on iPad
- FlywheelControl v1.2.6+ (includes Swift Playgrounds gesture fix)
- iPad hardware (momentum/inertia works great; haptics are best on iPhone)

### Steps
1. Open **Swift Playgrounds** and create a new **App** (SwiftUI template).
2. Add the package:
   - Tap **+** → **Swift Package**
   - Paste: `https://github.com/aweiner42/FlywheelControl`
3. Replace ContentView.swift with the minimal demo below (note the non-zero ranges) and run.

### Minimal Playground Demo

```swift
import SwiftUI
import FlywheelControl

struct ContentView: View {
    @State private var value: Double = 0        // current value in cm
    @State private var maxValue: Double = 150
    @State private var minValue: Double = 0
    @State private var spanCM: Double = 20       // visible range in cm

    var body: some View {
        VStack(spacing: 40) {
            Text("Value: \(value, specifier: "%.2f") cm")
                .font(.headline)

            FlywheelControl(
                trackImage: FlywheelControlResources.bundledRulerImage(),
                position: $value,
                maxOffset: $maxValue,
                minOffset: $minValue,
                spanCM: $spanCM
            )
            .frame(width: 60, height: 240)
        }
        .padding()
    }
}
```
This configuration mirrors the bundled demo app and is recommended for first-time exploration.
Use smaller `spanCM` values (e.g. 20) for a tactile feel. Drag interaction works in Swift Playgrounds on iPad and macOS starting in v1.2.6.

The demo ruler artwork is bundled with the FlywheelControl package and loaded via a public resource accessor.
When exploring the control, ensure `minOffset`, `maxOffset`, and `spanCM` are all greater than zero so the dial can move freely.

---

## 🎯 Example Integration

```swift
@State private var zoomPosition: Double = 0
@State private var minZoom: Double = 1
@State private var maxZoom: Double = 90
@State private var zoomSpan: Double = 20

var body: some View {
   FlywheelControl(
    trackImage: Image("RulerSkin"), // custom ruler skin from Assets
    position: $zoomPosition,        // current scroll/zoom value
    maxOffset: $maxZoom,            // maximum scroll value (must be > 0)
    minOffset: $minZoom,            // minimum scroll value (must be > 0)
    spanCM: $zoomSpan,              // visible range in cm (must be > 0)
    disableClampLimits: true
    )
    .onChange(of: zoomPosition) { newValue in
        zoomManager.adjustZoom(by: CGFloat(newValue))
    }
}
```

---

## 🔧 Requirements

- iOS 17.0+  
- macOS 12.0+  
- Swift 5.9+  
- SwiftUI + Combine

---

## 🧪 Previews & Tests

FlywheelControl includes:

- 🔍 SwiftUI Previews  
- 🧱 Modular design (no app dependencies)

---

## 🔄 Try It Live

Clone this repo and open `FlywheelDemoApp/FlywheelDemoApp.xcodeproj` to explore the latest refinements including improved momentum physics and control skinning.

---

## ✍️ Created by

Alan Weiner • [SIME Corp](https://simecorp.net)    
Inventor. Designer. Engineer. Collaborating with AI to shape intuitive interfaces.

Version 1.2.4 includes performance tuning, refined gesture handling, and support for custom ruler skins with clamped value ranges.
