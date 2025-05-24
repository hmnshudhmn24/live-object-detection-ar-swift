# 🚀 Live Object Detection App (ARKit + Vision)

An augmented reality iOS app that identifies real-world objects in real-time using ARKit, Vision, and CoreML.

## 📱 Features

- 🎥 Real-time object detection with iPhone camera
- 🧠 Powered by CoreML and Vision Framework
- 📦 Displays detected object names in AR space using RealityKit
- 🌐 Uses MobileNetV2 for on-device object classification

## 🛠️ Tech Stack

- `Swift`
- `ARKit`
- `RealityKit`
- `CoreML`
- `Vision`

## 🧑‍💻 How to Run

1. **Clone the Repository**

```bash
git clone https://github.com/yourusername/live-object-detection-ar.git
cd live-object-detection-ar
```

2. **Open the Xcode Project**

```bash
open LiveObjectDetection.xcodeproj
```

3. **Ensure Setup**

- ✅ Xcode 15 or later
- ✅ iOS 16+ deployment target
- ✅ Real device with A12 chip or later
- ✅ Add `MobileNetV2.mlmodel` to your project

4. **Run on a Real Device**

- ARKit and Vision require camera and neural engine – simulator will not work.


## 📷 Sample Output

> "Detected: Coffee Mug (0.93)" appears floating in front of the object in AR space.

## ✨ Future Work

- Add sound feedback
- Save detection history
- Toggle between object models
