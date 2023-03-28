//
//  LooksServiceProtocol.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

protocol LooksServiceProtocol {
    func loadLooks(page: Int) -> LooksResponse?
}

class LooksService: LooksServiceProtocol {
    
    func loadLooks(page: Int) -> LooksResponse? {
        let path = Bundle.main.path(forResource: "mock", ofType: "json")
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!)) else {
            return nil
        }
        return try? JSONDecoder().decode(LooksResponse.self, from: jsonData)
    }
}
