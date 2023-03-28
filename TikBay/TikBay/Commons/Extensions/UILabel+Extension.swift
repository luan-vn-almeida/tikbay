//
//  UILabel+Extension.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

extension UILabel {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
}
