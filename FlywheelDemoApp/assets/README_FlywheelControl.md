
# FlywheelControl

[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-blue)](https://swiftpackageindex.com/aweiner42/FlywheelControl)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-blue)](https://swiftpackageindex.com/aweiner42/FlywheelControl)

A tactile, momentum-based radial control for SwiftUI — inspired by analog flywheels.  
![FlywheelControl Logo](Assets/FlywheelIcon.png)

A SwiftUI-based, physics-inspired radial scroller for zoom, scrub, and value adjustments.  
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
- 🧠 Decoupled: just emits `delta` values — you decide what to do with them  

---

## 📦 Installation

### Swift Package Manager

**In Xcode:**

1. Go to `File → Add Packages…`  
2. Enter the URL: `https://github.com/aweiner42/FlywheelControl`  
3. Choose the latest version (e.g., `1.0.0`)

**Or add it to your `Package.swift`:**

```swift
.package(url: "https://github.com/aweiner42/FlywheelControl.git", from: "1.0.0")
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

---

## 🎯 Example Integration

```swift
let zoomManager = ZoomValueManager(
    getZoom: { camera.position.z },
    setZoom: { newZ in camera.position.z = newZ },
    min: -50,
    max: 50
)

FlywheelControl { delta in
    zoomManager.adjustZoom(by: delta)
}
```

---

## 🔧 Requirements

- iOS 15.0+  
- macOS 12.0+  
- Swift 5.9+  
- SwiftUI + Combine

---

## 🧪 Previews & Tests

FlywheelControl includes:

- 🔍 SwiftUI Previews  
- ✅ Unit tests for `ZoomValueManager` logic  
- 🧱 Modular design (no app dependencies)

---

## 🔄 Try It Live

Clone this repo and open `FlywheelDemoApp/FlywheelDemoApp.xcodeproj` to see the control in action.

---

## ✍️ Created by

Alan Weiner • [SIME Corp](https://simecorp.net)    
Inventor. Designer. Engineer. Collaborating with AI to shape intuitive interfaces.
