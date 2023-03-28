//
//  ImageService.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import Foundation
import AVKit

protocol ImageServiceProtocol: AnyObject {
    func downloadProfile(url string: String) async throws -> Data
    func downloadThumbnail(url string: String) async throws -> UIImage?
}

class ImageService: ImageServiceProtocol {
    
    func downloadProfile(url string: String) async throws -> Data {
        guard let url = URL(string: string) else {
            throw ServiceError.notFound
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func downloadThumbnail(url string: String) async throws -> UIImage? {
        do {
            guard let url = URL(string: string) else {
                return nil
            }
            let request = URLRequest(url: url)
            let cache = URLCache.shared
            if let cachedResponse = cache.cachedResponse(for: request) {
                return UIImage(data: cachedResponse.data)
            }
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            var time = try await asset.load(.duration)
            time.value = min(time.value, 2)
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            if let data = image.pngData(),
               let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)
            }
            return image
        } catch {
            return nil
        }
    }
}
