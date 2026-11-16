//
//  SampleData.swift
//  AeroEye
//
//  Hard-coded fleet data used to exercise the UI.
//

import Foundation

enum SampleData {
    static let sectorName = "Sector A · Plant 4"
    static let totalMachines = 24
    static let activeAlerts = 2
    static let uptime = "98%"

    static let machines: [Machine] = [
        Machine(
            id: "M-001",
            name: "Turbine 01",
            symbol: "wind",
            status: .normal,
            operational: 98.4,
            lastEvent: nil,
            trend: [97.2, 97.6, 97.4, 98.0, 97.8, 98.2, 98.4],
            metrics: [
                MachineMetric(label: "RPM", value: "3,240"),
                MachineMetric(label: "Vibration", value: "1.2 mm/s"),
                MachineMetric(label: "Temp", value: "62°C"),
                MachineMetric(label: "Last service", value: "12 days ago")
            ],
            recommendation: "No action required. Next scheduled inspection in 18 days."
        ),
        Machine(
            id: "M-014",
            name: "Conveyor B2",
            symbol: "arrow.left.arrow.right",
            status: .anomaly("Oil Leakage"),
            operational: 91.2,
            lastEvent: "Detected 12m ago",
            trend: [94.0, 93.5, 93.0, 92.4, 92.0, 91.6, 91.2],
            metrics: [
                MachineMetric(label: "Oil pressure", value: "2.1 bar"),
                MachineMetric(label: "Belt speed", value: "1.4 m/s"),
                MachineMetric(label: "Vibration", value: "4.2 mm/s"),
                MachineMetric(label: "Temp", value: "71°C")
            ],
            recommendation: "Inspect the gearbox seal and top up lubricant. Schedule maintenance within 24 hours."
        ),
        Machine(
            id: "M-008",
            name: "Hydraulic Pump 04",
            symbol: "drop",
            status: .warning("High Temp"),
            operational: 87.6,
            lastEvent: "Detected 34m ago",
            trend: [72.0, 75.0, 78.0, 76.0, 81.0, 83.0, 84.0],
            metrics: [
                MachineMetric(label: "Temp", value: "84°C"),
                MachineMetric(label: "Pressure", value: "148 bar"),
                MachineMetric(label: "Flow", value: "42 L/min"),
                MachineMetric(label: "Vibration", value: "3.1 mm/s")
            ],
            recommendation: "Reduce load and check the cooling circuit. Temperature is 9°C above the normal range."
        ),
        Machine(
            id: "M-021",
            name: "Compressor A3",
            symbol: "gearshape",
            status: .normal,
            operational: 97.1,
            lastEvent: nil,
            trend: [96.2, 96.8, 96.5, 97.0, 97.3, 96.9, 97.1],
            metrics: [
                MachineMetric(label: "Pressure", value: "8.4 bar"),
                MachineMetric(label: "Vibration", value: "1.6 mm/s"),
                MachineMetric(label: "Temp", value: "58°C"),
                MachineMetric(label: "Last service", value: "6 days ago")
            ],
            recommendation: "No action required. All readings are within range."
        ),
        Machine(
            id: "M-005",
            name: "Cooling Tower 07",
            symbol: "snowflake",
            status: .normal,
            operational: 99.2,
            lastEvent: nil,
            trend: [98.4, 98.8, 99.0, 98.9, 99.1, 99.0, 99.2],
            metrics: [
                MachineMetric(label: "Water temp", value: "24°C"),
                MachineMetric(label: "Fan speed", value: "620 rpm"),
                MachineMetric(label: "Flow", value: "88 L/min"),
                MachineMetric(label: "Last service", value: "21 days ago")
            ],
            recommendation: "No action required. Water temperature is stable."
        )
    ]
}
