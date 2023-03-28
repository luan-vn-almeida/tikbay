//
//  ReactionManager.swift
//  TikBay
//
//  Created by Luan Almeida on 28/03/23.
//

import UIKit

enum ReactionType {
    case heart
    case fire
    
    func icon() -> UIImage? {
        switch self {
        case .heart:
            return  UIImage(systemName: "heart.fill")
        case .fire:
            return UIImage(systemName: "flame.circle.fill")
        }
    }
}

//It is a example, in real world we must to use a local data base and sync with backend
class ReactionManager {
    
    static let shared = ReactionManager()
    private var heartStorage: [Int: Int] = [:]
    private var fireStorage: [Int: Int] = [:]
    
    func saveReact(id: Int, type: ReactionType) {
        if (type == .fire) {
            let totals = heartStorage[id] ?? 0
            heartStorage[id] = totals + 1
        } else {
            let totals = fireStorage[id] ?? 0
            fireStorage[id] = totals + 1
        }
    }
    
    func total(id: Int?, type: ReactionType) -> Int {
        guard let id = id else {
            return 0
        }
        if type == .fire {
            return heartStorage.first(where: { $0.key == id})?.value ?? 0
        } else {
            return fireStorage.first(where: { $0.key == id})?.value ?? 0
        }
    }
}
