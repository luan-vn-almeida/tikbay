//
//  Collection+Extension.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}
