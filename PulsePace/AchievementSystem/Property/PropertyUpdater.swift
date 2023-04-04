//
//  PropertyUpdater.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/31.
//

import Foundation

protocol PropertyUpdater: AnyObject {
    associatedtype T: Property
    var property: T? { get set }
}
