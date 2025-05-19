# FlywheelControl

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

## 💡 Usage

### 1. Import the Package

In **Xcode**:  
`File → Add Packages → Add Local…` or use the GitHub URL once published.

### 2. Use the View

```swift
import FlywheelControl

FlywheelControl { delta in
    zoomManager.adjustZoom(by: delta)
}
```

- `delta` is a `CGFloat` value emitted on each drag or spin frame.
- Works with both **touch** and **stylus** input.
- You can bind it to any logic — zoom, volume, timeline scrubbing, etc.

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

## 📦 Installation

Add this to your `Package.swift`:

```swift
.package(url: "https://github.com/aweiner42/FlywheelControl.git", from: "1.0.0")
```

Then:

```swift
.target(
    name: "YourApp",
    dependencies: ["FlywheelControl"]
)
```

---

## 🔄 Try It Live

Clone this repo and open `FlywheelDemoApp/FlywheelDemoApp.xcodeproj` to see the control in action.
---

## ✍️ Created by

Alan Weiner • [SIME Corp](https://simecorp.net)    
Inventor. Designer. Engineer. Collaborating with AI to shape intuitive interfaces.
