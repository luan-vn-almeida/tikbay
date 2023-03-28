//
//  HeaderComponentViewModel.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

protocol HeaderComponentViewModelProtocol: AnyObject {
    func downloadProfile(look: Look) async throws -> UIImage?
}

class HeaderComponentViewModel: HeaderComponentViewModelProtocol {
    
    private let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol = ImageService()) {
        self.imageService = imageService
    }
    
    func downloadProfile(look: Look) async throws -> UIImage? {
        do {
            let data = try await self.imageService.downloadProfile(url: look.profilePictureURL)
            return UIImage(data: data)
        } catch {
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
}
