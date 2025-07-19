//
//  FlywheelScroller.swift
//  ICMSLookingGlass
//
//  Created by Alan on 5/7/25.
//

import SwiftUI
import CoreHaptics
import Combine

public struct FlywheelControl: View {
    public var trackImage: Image?

    @Binding var position: Double
    @Binding var maxOffset: Double // passed from container
    @Binding var minOffset: Double // passed from container
    @Binding var spanCM: Double // passed from container

    @State private var velocity: Double = 0.0
    @State private var isDragging = false
    @State private var engine: CHHapticEngine?
    @State private var lastTick: Int = 0
    @State private var lastTranslation: CGFloat = 0.0
    @State private var timer: Timer?

    let tickSpacing: Double = 20
    let tickCount = Int(180 / 10)
    let updateInterval = 1.0 / 30.0

    public init(trackImage: Image? = nil, position: Binding<Double>, maxOffset: Binding<Double>, minOffset: Binding<Double>, spanCM: Binding<Double>) {
        self.trackImage = trackImage
        self._position = position
        self._maxOffset = maxOffset
        self._minOffset = minOffset
        self._spanCM = spanCM
    }

    public var body: some View {
        GeometryReader { geo in
            let visibleHeight = geo.size.height
            let scale :Double = visibleHeight / spanCM
            let totalControlHeight: Double = 300 * scale

            ZStack {
                if let image = trackImage {
                    image
                        .resizable()
                        .frame( height: totalControlHeight) // ruler skin height
                        .offset(y: {
                            let valueDisplay = position.truncatingRemainder(dividingBy: 100.0)
                            let valueShow = valueDisplay + 100.0
                            let offsetPX = -1 * (valueDisplay + 50) * scale
                            let testedOffsetPX = (offsetPX > (totalControlHeight * (-1)) ? offsetPX + (scale * 100) : offsetPX)
                            return testedOffsetPX
                        }())
                        .transaction { $0.animation = nil } // Disable implicit animation
                        .clipped()
                } else {
                    FlywheelTrack(angle: position, tickSpacing: tickSpacing, tickCount: tickCount)
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height) // match parent frame
            .background(Color.black.opacity(0.4).cornerRadius(10))
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: 0.2),
                        .init(color: .black, location: 0.8),
                        .init(color: .clear, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let dragDelta = value.translation.height - lastTranslation
                        lastTranslation = value.translation.height

                        let pixelsPerCm = visibleHeight / spanCM
                        let cmPerPixelDrag = 1.0 / pixelsPerCm
                        let newPosition = position + (-dragDelta) * cmPerPixelDrag
                        position = min(max(newPosition, minOffset), maxOffset)
                        isDragging = true
                        performTickHapticIfNeeded()
                    }
                    .onEnded { value in
                        isDragging = false
                        lastTranslation = 0

                        let finalDelta = value.predictedEndTranslation.height - value.translation.height
                        let predictedVelocity = finalDelta * 2

                        velocity = abs(predictedVelocity) < 5 ? 0 : predictedVelocity
                        position = position.rounded(.toNearestOrAwayFromZero)
                    }
            )
            .onTapGesture {
                velocity = 0
            }
            .onAppear {
                #if os(iOS)
                prepareHaptics()
                #endif
                runTimer(geo: geo)
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
                try? engine?.stop()
                isHapticsPrepared = false
            }
#if os(iOS)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                try? engine?.start()
                isHapticsPrepared = true
            }
#endif
        }
    }

    @State private var cancellable: AnyCancellable?

    private func runTimer(geo: GeometryProxy) {
        cancellable?.cancel()
        cancellable = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isDragging { return }

                if abs(velocity) > 0.1 {
                    let visibleHeight = geo.size.height
                    let pixelsPerCm = visibleHeight / spanCM
                    let cmPerPixelDrag = 1.0 / pixelsPerCm
                    withAnimation(.none) {
                        position += (-velocity * updateInterval) * cmPerPixelDrag
                        position = min(max(position.rounded(.toNearestOrAwayFromZero), minOffset), maxOffset) // Clamp position
                    }
                    if position == minOffset || position == maxOffset {
                        velocity = 0 // Stop spin at limits
                        position = position.rounded(.toNearestOrAwayFromZero) // Snap to whole cm
                    }

                    velocity *= 0.98

                    performTickHapticIfNeeded()
                } else if velocity != 0 {
                    velocity = 0
                    position = position.rounded(.toNearestOrAwayFromZero) // Snap to whole cm
                }
            }
    }
    
    @State private var isHapticsPrepared = false

    private func performTickHapticIfNeeded() {
        guard isHapticsPrepared, let engine = engine else { return }

        let currentTick = Int(position.rounded(.toNearestOrAwayFromZero))
        if currentTick != lastTick {
            lastTick = currentTick

            do {
                let tickEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
                let pattern = try CHHapticPattern(events: [tickEvent], parameters: [])
                let player = try engine.makePlayer(with: pattern)
                try player.start(atTime: 0)
            } catch {
                print("⚠️ Haptic tick failed: \(error.localizedDescription)")
            }
        }
    }
    
#if os(iOS)
    private func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            isHapticsPrepared = true
        } catch {
            print("⚠️ Failed to start haptics engine: \(error.localizedDescription)")
            isHapticsPrepared = false
        }
    }
#endif
}

#if DEBUG
import SwiftUI

#Preview("FlywheelControl Demo") {
    FlywheelControl(
        position: .constant(0.0),
        maxOffset: .constant(150.0),
        minOffset: .constant(-150.0),
        spanCM: .constant(200.0)
    )
    .frame(width: 60, height: 240)
    .padding()
}
#endif
