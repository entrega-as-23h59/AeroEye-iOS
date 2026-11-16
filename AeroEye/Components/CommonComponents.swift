//
//  CommonComponents.swift
//  AeroEye
//
//  Small reusable views that keep the screens visually consistent.
//

import SwiftUI

// MARK: - Button style

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Status

struct StatusPill: View {
    let text: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(tint)
                .frame(width: 5, height: 5)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundColor(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(tint.opacity(0.10)))
        .overlay(Capsule().stroke(tint.opacity(0.20), lineWidth: 1))
    }
}

// MARK: - Statistics

struct StatTile: View {
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(tint)
                    .frame(width: 6, height: 6)

                Text(label)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundColor(AeroTheme.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AeroTheme.ink)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .aeroCard(cornerRadius: 14)
    }
}

// MARK: - Sparkline

struct Sparkline: View {
    let data: [Double]
    var tint: Color = AeroTheme.navy
    var showsFill: Bool = true

    var body: some View {
        GeometryReader { geo in
            let points = normalizedPoints(in: geo.size)

            ZStack {
                if showsFill {
                    Path { path in
                        guard let first = points.first, let last = points.last else { return }
                        path.move(to: CGPoint(x: first.x, y: geo.size.height))
                        path.addLine(to: first)
                        points.dropFirst().forEach { path.addLine(to: $0) }
                        path.addLine(to: CGPoint(x: last.x, y: geo.size.height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.18), tint.opacity(0.01)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }

                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    points.dropFirst().forEach { path.addLine(to: $0) }
                }
                .stroke(
                    tint,
                    style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round)
                )
            }
        }
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard data.count > 1, let minimum = data.min(), let maximum = data.max() else {
            return [
                CGPoint(x: 0, y: size.height / 2),
                CGPoint(x: size.width, y: size.height / 2)
            ]
        }

        let range = maximum - minimum
        let stepX = size.width / CGFloat(data.count - 1)
        let inset: CGFloat = 2
        let usableHeight = max(size.height - (inset * 2), 1)

        return data.enumerated().map { index, value in
            let ratio = range == 0 ? 0.5 : (value - minimum) / range
            return CGPoint(
                x: CGFloat(index) * stepX,
                y: inset + (usableHeight * CGFloat(1 - ratio))
            )
        }
    }
}

// MARK: - Drone glyph

struct DroneGlyph: View {
    var color: Color = AeroTheme.navy
    var lineWidth: CGFloat = 1.6
    var size: CGFloat = 26

    var body: some View {
        let unit = size / 26
        let armLength = 15 * unit
        let rotorSize = 7 * unit
        let rotorOffset = 9.5 * unit

        return ZStack {
            Capsule()
                .fill(color)
                .frame(width: armLength, height: lineWidth)
                .rotationEffect(.degrees(45))

            Capsule()
                .fill(color)
                .frame(width: armLength, height: lineWidth)
                .rotationEffect(.degrees(-45))

            ForEach(0..<4, id: \.self) { index in
                let angle = (Double(index) * .pi / 2) + (.pi / 4)

                Circle()
                    .stroke(color, lineWidth: lineWidth)
                    .frame(width: rotorSize, height: rotorSize)
                    .offset(
                        x: CGFloat(cos(angle)) * rotorOffset,
                        y: CGFloat(sin(angle)) * rotorOffset
                    )
            }

            RoundedRectangle(cornerRadius: 2.5 * unit, style: .continuous)
                .fill(color)
                .frame(width: 9 * unit, height: 7 * unit)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Placeholder visuals

struct BlueprintGrid: View {
    var spacing: CGFloat = 30

    var body: some View {
        Canvas { context, size in
            var path = Path()
            var x: CGFloat = 0

            while x <= size.width {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                x += spacing
            }

            var y: CGFloat = 0

            while y <= size.height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                y += spacing
            }

            context.stroke(path, with: .color(.white.opacity(0.07)), lineWidth: 0.6)
        }
        .allowsHitTesting(false)
    }
}

struct ViewfinderCorners: Shape {
    var inset: CGFloat
    var length: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let minX = rect.minX + inset
        let maxX = rect.maxX - inset
        let maxY = rect.maxY - inset

        // Bottom left
        path.move(to: CGPoint(x: minX + length, y: maxY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.addLine(to: CGPoint(x: minX, y: maxY - length))

        // Bottom right
        path.move(to: CGPoint(x: maxX, y: maxY - length))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: maxX - length, y: maxY))

        return path
    }
}

// MARK: - Feature placeholder panel

struct FeaturePlaceholderPanel<Icon: View>: View {
    let status: String
    let statusTint: Color
    let title: String
    let message: String
    let badge: String
    let icon: Icon

    init(
        status: String,
        statusTint: Color,
        title: String,
        message: String,
        badge: String,
        @ViewBuilder icon: () -> Icon
    ) {
        self.status = status
        self.statusTint = statusTint
        self.title = title
        self.message = message
        self.badge = badge
        self.icon = icon()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x0A1733), Color(hex: 0x18336F)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [AeroTheme.accentBright.opacity(0.16), .clear],
                center: .center,
                startRadius: 10,
                endRadius: 280
            )

            BlueprintGrid()

            ViewfinderCorners(inset: 18, length: 26)
                .stroke(
                    Color.white.opacity(0.28),
                    style: StrokeStyle(lineWidth: 1.2, lineCap: .round)
                )

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 92, height: 92)

                    Circle()
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        .frame(width: 92, height: 92)

                    icon
                        .foregroundColor(.white.opacity(0.95))
                }

                VStack(spacing: 7) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text(message)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.62))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 250)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(badge)
                    .font(.system(size: 10.5, weight: .semibold))
                    .tracking(1.4)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color.white.opacity(0.10)))
                    .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1))
            }
            .padding(24)
        }
        .frame(height: 430)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            HStack(spacing: 6) {
                Circle()
                    .fill(statusTint)
                    .frame(width: 6, height: 6)

                Text(status)
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.1)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.10)))
            .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
            .padding(18),
            alignment: .topLeading
        )
        .overlay(
            Image(systemName: "camera")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.white.opacity(0.10)))
                .overlay(Circle().stroke(Color.white.opacity(0.16), lineWidth: 1))
                .padding(18),
            alignment: .topTrailing
        )
        .shadow(color: AeroTheme.navy.opacity(0.18), radius: 24, x: 0, y: 12)
    }
}
