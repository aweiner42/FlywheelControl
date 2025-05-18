//
//  ZoomValueManager.swift
//  FlywheelControl
//
//  Created by Alan on 5/17/25.
//


//
//  ZoomValueManager.swift
//  ICMSLookingGlass
//
//  Created by Alan on 5/7/25.
//


import SwiftUI
import Combine

@MainActor
public class ZoomValueManager: ObservableObject {
    public init(getZoom: @escaping () -> Float, setZoom: @escaping (Float) -> Void, min: Float = -40, max: Float = 50) {
        self.getZoom = getZoom
        self.setZoom = setZoom
        self.minZoom = min
        self.maxZoom = max
        self.currentZoom = CGFloat(getZoom())
    }

    private let getZoom: () -> Float
    private let setZoom: (Float) -> Void

    public let minZoom: Float
    public let maxZoom: Float

    @Published public var currentZoom: CGFloat {
        didSet {
            applyZoomToTarget(currentZoom)
        }
    }

    public func adjustZoom(by delta: CGFloat) {
        let newZ = getZoom() - Float(delta)
        let clampedZ = max(minZoom, min(maxZoom, newZ))
        setZoom(clampedZ)
        currentZoom = CGFloat(clampedZ)
    }

    private func applyZoomToTarget(_ zoom: CGFloat) {
        let clampedZ = max(minZoom, min(maxZoom, Float(zoom)))
        setZoom(clampedZ)
    }
}
