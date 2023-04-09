//
//  DateComponentsFormatter+Formatters.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/07.
//

import Foundation

extension DateComponentsFormatter {
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()

        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        return formatter
    }()
}
