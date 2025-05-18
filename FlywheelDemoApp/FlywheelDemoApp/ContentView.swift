//
//  ContentView.swift
//  FlywheelDemoApp
//
//  Created by Alan on 5/18/25.
//

import SwiftUI
import FlywheelControl

struct ContentView: View {
    @State private var position: CGFloat = 0
    @State private var maxOffset: CGFloat = 150

    var body: some View {
        VStack(spacing: 40) {
            Text("Position: \(position, specifier: "%.2f")")
                .font(.headline)

            FlywheelControl { delta in
                let newPosition = position + delta * 10
                position = min(max(newPosition, -maxOffset), maxOffset)
            }
            .frame(width: 60, height: 240)

            TrackView(position: position, maxOffset: $maxOffset)
                .frame(height: 40)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
