//
//  Machine.swift
//  AeroEye
//
//  Local demo models. No networking is used anywhere in this build.
//

import SwiftUI

struct MachineMetric: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

enum MachineStatus {
    case normal
    case anomaly(String)
    case warning(String)

    var label: String {
        switch self {
        case .normal:
            return "Normal"
        case .anomaly(let detail):
            return "Anomaly: \(detail)"
        case .warning(let detail):
            return "Warning: \(detail)"
        }
    }

    var isNormal: Bool {
        if case .normal = self {
            return true
        }
        return false
    }

    var tint: Color {
        switch self {
        case .normal:
            return AeroTheme.success
        case .anomaly:
            return AeroTheme.danger
        case .warning:
            return AeroTheme.warning
        }
    }
}

struct Machine: Identifiable {
    let id: String
    let name: String
    let symbol: String
    let status: MachineStatus
    let operational: Double?
    let lastEvent: String?
    let trend: [Double]
    let metrics: [MachineMetric]
    let recommendation: String
}
