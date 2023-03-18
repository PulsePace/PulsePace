//
//  HitObjectTimelineView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

protocol HitObjectTimelineView: View {
    var startTime: Double { get }
    var endTime: Double { get }
}
