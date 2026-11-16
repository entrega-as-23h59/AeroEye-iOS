//
//  ARModeView.swift
//  AeroEye
//
//  Placeholder for the AR experience. Intentionally empty for now.
//

import SwiftUI

struct ARModeView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    FeaturePlaceholderPanel(
                        status: "PREVIEW",
                        statusTint: AeroTheme.accentBright,
                        title: "AR diagnostics",
                        message: "Point your camera at a machine and live insights will be anchored to it.",
                        badge: "COMING SOON"
                    ) {
                        Image(systemName: "cube")
                            .font(.system(size: 44, weight: .thin))
                    }

                    Text("Placeholder screen · AR mode")
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
            Text("AUGMENTED REALITY")
                .font(.system(size: 10.5, weight: .semibold))
                .tracking(1.2)
                .foregroundColor(AeroTheme.navy.opacity(0.55))

            Text("AR Mode")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(AeroTheme.ink)

            Text("In-situ machine insights")
                .font(.system(size: 13))
                .foregroundColor(AeroTheme.secondary)
        }
    }
}

struct ARModeView_Previews: PreviewProvider {
    static var previews: some View {
        ARModeView()
    }
}
