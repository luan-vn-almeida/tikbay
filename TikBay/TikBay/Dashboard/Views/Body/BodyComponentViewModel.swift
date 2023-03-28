//
//  BodyComponentViewModel.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

protocol BodyComponentViewModelProtocol: AnyObject {
    var looks: [Look] { get set }
}

class BodyComponentViewModel: BodyComponentViewModelProtocol {
    var looks: [Look] = []
    
}
