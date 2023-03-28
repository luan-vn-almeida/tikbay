//
//  DashboardViewModel.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

protocol DashboardViewModelOutput: AnyObject {
    
    func reloadCollection()
    func reloadProfile()
}

protocol DashboardViewModelProtocol: AnyObject {
    
    var looks: [Look] { get }
    var currentLook: Look? { get }
    
    var delegate: DashboardViewModelOutput? { get set }
    
    func showLook(row: Int)
    func loadData() async
    func nextPage()
}

class DashboardViewModel: DashboardViewModelProtocol {
    
    private var currentPage: Int = 1
    
    var looks: [Look] = []
    var currentLook: Look? = nil
    let looksService: LooksServiceProtocol
    var delegate: DashboardViewModelOutput?
    
    init(looksService: LooksServiceProtocol = LooksService()) {
        self.looksService = looksService
    }
    
    func loadData() async {
        guard let lookResponse = looksService.loadLooks(page: currentPage) else {
            return
        }
        currentPage += 1
        looks.append(contentsOf: lookResponse.looks)
        delegate?.reloadCollection()
        showLook(row: 0)
    }
    
    func showLook(row: Int) {
        guard let look = looks[safe: row] else {
            return
        }
        currentLook = look
        delegate?.reloadProfile()
    }
    
    func nextPage() {
        print("Calling the next page")
    }
}
