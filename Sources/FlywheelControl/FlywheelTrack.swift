//
//  FlywheelTrack.swift
//  FlywheelControl
//
//  Created by Alan on 5/18/25.
//


import SwiftUI

public struct FlywheelTrack: Shape {
    var angle: Double
    let tickSpacing: Double
    let tickCount: Int

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.midX
        let offset = CGFloat(angle.truncatingRemainder(dividingBy: tickSpacing)) * 0.5

        for i in 0..<tickCount {
            let y = rect.midY + CGFloat(i - tickCount / 2) * 12 + offset
            if y > 0 && y < rect.maxY {
                path.move(to: CGPoint(x: centerX - 4, y: y))
                path.addLine(to: CGPoint(x: centerX + 4, y: y))
            }
        }

        return path
    }
}