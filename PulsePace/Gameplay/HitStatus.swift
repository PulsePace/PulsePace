//
//  HitStatus.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

enum HitStatus {
    case perfect
    case good
    case miss
    case death

    var description: String {
       switch self {
       case .perfect:
           return "Perfect"
       case .good:
           return "Good"
       case .miss:
           return "Miss"
       case .death:
           return "YOU DIED"
       }
     }
}
