//
//  ViewConfiguration.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation

protocol ViewConfiguration: AnyObject {
    func buildLayout()
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    
    func buildLayout() {
        self.buildViewHierarchy()
        self.setupConstraints()
        self.configureViews()
    }
    
    func configureViews() { }
}
