//
//  TrackView.swift
//  FlywheelDemoApp
//
//  Created by Alan on 5/18/25.
//

import SwiftUI

struct TrackView: View {
    let position: CGFloat
    @Binding var maxOffset: CGFloat

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let dotRadius: CGFloat = 10
            let clampedPosition = min(max(position, -maxOffset), maxOffset)

            Color.clear.onAppear {
                maxOffset = width / 2 - dotRadius
            }

            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: dotRadius * 2, height: dotRadius * 2)
                    .offset(x: clampedPosition)
                    .animation(.easeOut(duration: 0.1), value: clampedPosition)
            }
        }
    }
}
