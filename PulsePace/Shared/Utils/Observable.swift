//
//  Observable.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

protocol Observable: AnyObject {
    var observers: [Observer] { get set }
}

extension Observable {
    func addObserver(_ observer: Observer) {
        removeObserver(observer)
        observers.append(observer)
    }

    func removeObserver(_ observer: Observer) {
        observers = observers.filter { $0 !== observer }
    }

    func notifyObservers() {
        for observer in observers {
            observer.update(with: self)
        }
    }
}
