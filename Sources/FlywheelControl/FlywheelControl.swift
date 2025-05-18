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
    public var onDelta: (CGFloat) -> Void

    @State private var angle: Double = 0.0
    @State private var velocity: Double = 0.0
    @State private var isDragging = false
    @State private var engine: CHHapticEngine?
    @State private var lastTick: Int = 0
    @State private var lastTranslation: CGFloat = 0.0
    @State private var timer: Timer?

    let width: CGFloat = 40
    let height: CGFloat = 225
    let tickSpacing: Double = 20
    let tickCount = Int(180 / 10)
    let updateInterval = 1.0 / 60.0

    public init(onDelta: @escaping (CGFloat) -> Void) {
        self.onDelta = onDelta
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                FlywheelTrack(angle: angle, tickSpacing: tickSpacing, tickCount: tickCount)
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    .frame(width: width, height: height)
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
            }
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let dragDelta = value.translation.height - lastTranslation
                        lastTranslation = value.translation.height

                        angle += dragDelta
                        isDragging = true
                        performTickHapticIfNeeded()

                        onDelta(CGFloat(dragDelta * 0.01))  // emit small delta
                    }
                    .onEnded { value in
                        isDragging = false
                        lastTranslation = 0

                        let finalDelta = value.predictedEndTranslation.height - value.translation.height
                        let predictedVelocity = finalDelta * 2

                        velocity = abs(predictedVelocity) < 5 ? 0 : predictedVelocity
                    }
            )
            .onTapGesture {
                velocity = 0
            }
            .onAppear {
                #if os(iOS)
                prepareHaptics()
                #endif
                runTimer()
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

    private func runTimer() {
        cancellable?.cancel()
        cancellable = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isDragging { return }

                if abs(velocity) > 0.1 {
                    angle += velocity * updateInterval
                    velocity *= 0.94

                    onDelta(CGFloat(velocity * 0.001))
                    performTickHapticIfNeeded()
                } else if velocity != 0 {
                    velocity = 0
                }
            }
    }
    
    @State private var isHapticsPrepared = false
    

    private func performTickHapticIfNeeded() {
        guard isHapticsPrepared, let engine = engine else { return }

        let currentTick = Int((angle / tickSpacing).rounded())
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
    FlywheelControl { delta in
        print("Delta in preview: \(delta)")
    }
    .frame(width: 60, height: 240)
    .padding()
}
#endif
