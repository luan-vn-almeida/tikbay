//
//  ReactionViewModel.swift
//  TikBay
//
//  Created by Luan Almeida on 28/03/23.
//

import Foundation

protocol ReactionViewModelProtocol: AnyObject {
    
    var type: ReactionType { get set }
    var look: Look? { get set }
    
    func loadReactions() -> String
}

class ReactionViewModel: ReactionViewModelProtocol {
    
    var type: ReactionType = .fire
    var look: Look?
    
    func loadReactions() -> String {
        let total = ReactionManager.shared.total(id: look?.id, type: type)
        return String(describing: total)
    }
}
