//
//  TrackView.swift
//  FlywheelDemoApp
//
//  Created by Alan on 5/18/25.
//

import SwiftUI

struct TrackView: View {
    let position: CGFloat
    @Binding var maxOffset: Double
    @Binding var minOffset: Double

    var body: some View {
        GeometryReader { geo in
            let dotRadius: CGFloat = 10
            let width = geo.size.width - dotRadius
          
            let displayPosition = width*(position-minOffset)/(maxOffset-minOffset) - width/2

            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: dotRadius * 2, height: dotRadius * 2)
                    .offset(x: displayPosition)
                    .animation(.easeOut(duration: 0.1), value: displayPosition)
            }
        }
    }
}
