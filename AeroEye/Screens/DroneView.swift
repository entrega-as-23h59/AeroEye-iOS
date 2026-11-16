//
//  DroneView.swift
//  AeroEye
//
//  Placeholder for the live drone camera. Intentionally empty for now.
//

import SwiftUI

struct DroneView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    FeaturePlaceholderPanel(
                        status: "STANDBY",
                        statusTint: AeroTheme.warningBright,
                        title: "Camera feed",
                        message: "The live drone stream will appear on this screen once the camera is connected.",
                        badge: "COMING SOON"
                    ) {
                        DroneGlyph(
                            color: .white.opacity(0.95),
                            lineWidth: 2.2,
                            size: 44
                        )
                    }

                    Text("Placeholder screen · Drone camera view")
                        .font(.system(size: 11.5))
                        .foregroundColor(AeroTheme.tertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 28)
                .frame(maxWidth: 720)
                .frame(width: proxy.size.width)
            }
            .background(AeroTheme.canvas)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("DRONE 02 · LIVE LINK")
                .font(.system(size: 10.5, weight: .semibold))
                .tracking(1.2)
                .foregroundColor(AeroTheme.navy.opacity(0.55))

            Text("Live Stream")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(AeroTheme.ink)

            Text("Drone 02 · Camera view")
                .font(.system(size: 13))
                .foregroundColor(AeroTheme.secondary)
        }
    }
}

struct DroneView_Previews: PreviewProvider {
    static var previews: some View {
        DroneView()
    }
}
