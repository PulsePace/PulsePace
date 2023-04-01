//
//  Observer.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

protocol Observer: AnyObject {
    func update(with observable: Observable)
}
