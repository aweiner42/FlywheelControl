//
//  ContentView.swift
//  FlywheelDemoApp
//
//  Created by Alan on 5/18/25.
//

import SwiftUI
import FlywheelControl

struct ContentView: View {
    @State private var value: Double = 0 // current value in cm
    @State private var maxValue: Double = 150
    @State private var minValue: Double = 0
    // since dial is 0 - 100 in one direction that means this control is either + or - but not both
    
    @State private var spanCM: Double = 20 // desired span size in cm

    var body: some View {
        VStack(spacing: 40) {
            Text("Value: \(value, specifier: "%.2f") cm")
                .font(.headline)

            FlywheelControl(
                trackImage: Image("combined_ruler_image"),
                position: $value,
                maxOffset: $maxValue,
                minOffset: $minValue,
                spanCM: $spanCM
            )
            .frame(width: 60, height: 240)

            TrackView(position: value, maxOffset: $maxValue, minOffset: $minValue)
                .frame(height: 40)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
