//
//  ScoreManagable.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

protocol ScoreManagable {
    var isHit: Bool { get }
    func checkOnInput(input: GameInputData, scoreManager: ScoreManager)

    func checkOnInputEnd(input: GameInputData, scoreManager: ScoreManager)
}
