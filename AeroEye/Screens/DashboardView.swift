//
//  DashboardView.swift
//  AeroEye
//

import SwiftUI

struct DashboardView: View {
    var onSignOut: () -> Void

    @State private var query = ""
    @State private var showSignOut = false

    private var filteredMachines: [Machine] {
        let search = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !search.isEmpty else {
            return SampleData.machines
        }

        return SampleData.machines.filter { machine in
            machine.name.lowercased().contains(search)
                || machine.id.lowercased().contains(search)
                || machine.status.label.lowercased().contains(search)
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    searchField
                    statsRow
                    machineSection
                    footerNote
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 28)
                .frame(maxWidth: 720)
                .frame(width: proxy.size.width)
            }
            .background(AeroTheme.canvas)
        }
        .confirmationDialog(
            "Sign out of AeroEye?",
            isPresented: $showSignOut,
            titleVisibility: .visible
        ) {
            Button("Sign Out", role: .destructive) {
                onSignOut()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You can sign back in with any email and password.")
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("AEROEYE · FLEET MONITOR")
                    .font(.system(size: 10.5, weight: .semibold))
                    .tracking(1.2)
                    .foregroundColor(AeroTheme.navy.opacity(0.55))

                Text("Machine Monitor")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(AeroTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text("\(SampleData.sectorName) · Updated just now")
                    .font(.system(size: 13))
                    .foregroundColor(AeroTheme.secondary)
            }

            Spacer(minLength: 8)

            Button {
                showSignOut = true
            } label: {
                ZStack {
                    Circle()
                        .fill(AeroTheme.surface)

                    Circle()
                        .stroke(AeroTheme.hairline, lineWidth: 1)

                    Text("RA")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AeroTheme.navy)
                }
                .frame(width: 42, height: 42)
                .overlay(
                    Circle()
                        .fill(AeroTheme.success)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(AeroTheme.surface, lineWidth: 2)
                        )
                        .offset(x: 1, y: 1),
                    alignment: .bottomTrailing
                )
                .shadow(color: AeroTheme.navy.opacity(0.08), radius: 8, x: 0, y: 3)
            }
            .buttonStyle(PressableButtonStyle())
            .accessibilityLabel("Account menu")
        }
    }

    // MARK: - Search

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AeroTheme.tertiary)

            TextField("Search machines or IDs", text: $query)
                .font(.system(size: 15))
                .foregroundColor(AeroTheme.ink)
                .accentColor(AeroTheme.navy)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.search)

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(AeroTheme.tertiary)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AeroTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AeroTheme.hairline, lineWidth: 1)
        )
        .shadow(color: AeroTheme.navy.opacity(0.03), radius: 10, x: 0, y: 4)
    }

    // MARK: - Statistics

    private var statsRow: some View {
        HStack(spacing: 10) {
            StatTile(
                label: "Total machines",
                value: "\(SampleData.totalMachines)",
                tint: AeroTheme.navy
            )

            StatTile(
                label: "Active alerts",
                value: "\(SampleData.activeAlerts)",
                tint: AeroTheme.warning
            )

            StatTile(
                label: "Uptime",
                value: SampleData.uptime,
                tint: AeroTheme.success
            )
        }
    }

    // MARK: - Machine list

    private var machineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Machines")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AeroTheme.ink)

                Spacer()

                Text(resultSummary)
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(AeroTheme.secondary)
            }

            if filteredMachines.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(filteredMachines) { machine in
                        MachineCard(machine: machine)
                    }
                }
            }
        }
    }

    private var resultSummary: String {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "\(SampleData.machines.count) of \(SampleData.totalMachines)"
        }

        let count = filteredMachines.count
        return "\(count) result\(count == 1 ? "" : "s")"
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 26, weight: .light))
                .foregroundColor(AeroTheme.tertiary)

            Text("No machines found")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AeroTheme.ink)

            Text("Try a different name or machine ID.")
                .font(.system(size: 13))
                .foregroundColor(AeroTheme.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 44)
        .aeroCard()
    }

    private var footerNote: some View {
        Text("Sample fleet data · Demo build · No connection required")
            .font(.system(size: 11.5))
            .foregroundColor(AeroTheme.tertiary)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
    }
}

// MARK: - Machine card

struct MachineCard: View {
    let machine: Machine

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader
            statusRow

            if case .warning = machine.status,
               let temperature = machine.metrics.first(where: { $0.label == "Temp" }) {
                temperatureRow(temperature)
            }

            if isExpanded {
                expandedDetails
            }
        }
        .padding(16)
        .aeroCard()
    }

    private var cardHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(AeroTheme.navyTint)

                Image(systemName: machine.symbol)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(AeroTheme.navy)
            }
            .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 3) {
                Text(machine.name)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(AeroTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                HStack(spacing: 5) {
                    Text("Machine ID: \(machine.id)")

                    if let lastEvent = machine.lastEvent {
                        Text("·")
                        Text(lastEvent)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(AeroTheme.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            }

            Spacer(minLength: 4)

            if !machine.status.isNormal {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(machine.status.tint)
                    .padding(.top, 2)
            }
        }
    }

    private var statusRow: some View {
        HStack(spacing: 10) {
            StatusPill(text: machine.status.label, tint: machine.status.tint)

            if machine.status.isNormal, let operational = machine.operational {
                Text("Operational: \(String(format: "%.1f", operational))%")
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(AeroTheme.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Sparkline(data: machine.trend, tint: AeroTheme.success)
                    .frame(width: 58, height: 20)
            }

            Spacer(minLength: 0)

            if !machine.status.isNormal {
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        Text(isExpanded ? "Hide Details" : "View Details")

                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundColor(AeroTheme.navy)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(AeroTheme.navyTint.opacity(0.8)))
                    .overlay(Capsule().stroke(AeroTheme.hairline, lineWidth: 1))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }

    private func temperatureRow(_ temperature: MachineMetric) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Temperature")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AeroTheme.secondary)

                Text(temperature.value)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AeroTheme.ink)
            }

            Spacer(minLength: 8)

            Sparkline(data: machine.trend, tint: AeroTheme.warning)
                .frame(width: 110, height: 30)
        }
    }

    private var expandedDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle()
                .fill(AeroTheme.hairline)
                .frame(height: 1)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ],
                spacing: 8
            ) {
                ForEach(machine.metrics) { metric in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(metric.label)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AeroTheme.secondary)

                        Text(metric.value)
                            .font(.system(size: 14.5, weight: .semibold))
                            .foregroundColor(AeroTheme.ink)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(AeroTheme.canvas)
                    )
                }
            }

            HStack(alignment: .top, spacing: 9) {
                Image(systemName: "lightbulb")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AeroTheme.navy)
                    .padding(.top, 1)

                Text(machine.recommendation)
                    .font(.system(size: 12.5))
                    .foregroundColor(AeroTheme.navyMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AeroTheme.navyTint)
            )
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(onSignOut: {})
    }
}
