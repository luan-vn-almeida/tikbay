//
//  BodyCollectionViewModel.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

protocol BodyCollectionViewModelOutput: AnyObject {
    
    func loadedThumbnaill(image: UIImage)
    func loadedBody(description: String)
    
    func loadVideoAndAudio(videoURL: URL, audioURL: URL)
}

protocol BodyCollectionViewModelProtocol {
    
    var delegate: BodyCollectionViewModelOutput? { get set }
    func set(look: Look)
    func loadVideo()
    
    func saveReact(type: ReactionType)
    func getTotalReacts(type: ReactionType) -> String
}

class BodyCollectionViewModel: BodyCollectionViewModelProtocol {
    
    private var currentLook: Look? = nil
    private var imageService: ImageServiceProtocol
    weak var delegate: BodyCollectionViewModelOutput?
    
    init(imageService: ImageServiceProtocol = ImageService()) {
        self.imageService = imageService
    }
    
    func loadVideo() {
        guard let look = currentLook,
              let videoURL = URL(string: look.compressedForIosURL),
              let audioURL = URL(string: look.songURL) else {
            return
        }
        delegate?.loadVideoAndAudio(videoURL: videoURL, audioURL: audioURL)
    }
    
    func set(look: Look) {
        self.currentLook = look
        Task {
            guard let thumbnail = try await imageService.downloadThumbnail(url: look.compressedForIosURL) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.loadedThumbnaill(image: thumbnail)
                self?.delegate?.loadedBody(description: look.body)
            }
        }
    }
    
    func saveReact(type: ReactionType) {
        ReactionManager.shared.saveReact(id: currentLook?.id ?? 0, type: type)
    }
    
    func getTotalReacts(type: ReactionType) -> String {
        let total = ReactionManager.shared.total(id: currentLook?.id, type: type)
        return String(describing: total)
    }
}
