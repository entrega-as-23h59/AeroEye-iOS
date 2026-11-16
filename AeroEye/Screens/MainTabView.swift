//
//  MainTabView.swift
//  AeroEye
//

import SwiftUI
import UIKit

enum AeroTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case drone = "Drone"
    case ar = "AR"

    var id: String { rawValue }
}

struct MainTabView: View {
    var onSignOut: () -> Void

    @State private var selection: AeroTab = .dashboard

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                AeroTheme.canvas

                DashboardView(onSignOut: onSignOut)
                    .opacity(selection == .dashboard ? 1 : 0)
                    .allowsHitTesting(selection == .dashboard)
                    .accessibilityHidden(selection != .dashboard)

                DroneView()
                    .opacity(selection == .drone ? 1 : 0)
                    .allowsHitTesting(selection == .drone)
                    .accessibilityHidden(selection != .drone)

                ARModeView()
                    .opacity(selection == .ar ? 1 : 0)
                    .allowsHitTesting(selection == .ar)
                    .accessibilityHidden(selection != .ar)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            AeroTabBar(selection: $selection)
        }
        .background(AeroTheme.canvas.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: selection)
    }
}

// MARK: - Bottom page selector

struct AeroTabBar: View {
    @Binding var selection: AeroTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AeroTab.allCases) { tab in
                AeroTabBarItem(
                    tab: tab,
                    isSelected: selection == tab,
                    action: {
                        select(tab)
                    }
                )
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(
            AeroTheme.surface
                .ignoresSafeArea(edges: .bottom)
                .overlay(
                    Rectangle()
                        .fill(AeroTheme.hairline)
                        .frame(height: 0.5),
                    alignment: .top
                )
        )
    }

    private func select(_ tab: AeroTab) {
        guard tab != selection else { return }

        UISelectionFeedbackGenerator().selectionChanged()

        withAnimation(.easeOut(duration: 0.18)) {
            selection = tab
        }
    }
}

private struct AeroTabBarItem: View {
    let tab: AeroTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                icon
                    .frame(width: 26, height: 24)

                Text(tab.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))

                Capsule()
                    .fill(indicatorColor)
                    .frame(width: 18, height: 3)
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(tab.rawValue)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var icon: some View {
        switch tab {
        case .dashboard:
            Image(systemName: isSelected ? "square.grid.2x2.fill" : "square.grid.2x2")
                .font(.system(size: 19, weight: .medium))

        case .drone:
            DroneGlyph(
                color: foregroundColor,
                lineWidth: isSelected ? 1.9 : 1.6,
                size: 24
            )

        case .ar:
            Image(systemName: isSelected ? "cube.fill" : "cube")
                .font(.system(size: 20, weight: .medium))
        }
    }

    private var foregroundColor: Color {
        isSelected ? AeroTheme.navy : AeroTheme.secondary
    }

    private var indicatorColor: Color {
        isSelected ? AeroTheme.navy : Color.clear
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(onSignOut: {})
    }
}
