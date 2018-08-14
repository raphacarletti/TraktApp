//
//  ImageAPIService.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-14.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

enum ImageType {
    case Poster
    case Backdrop
}

class ImageAPIService {
    // MARK: - Variables
    private static var sharedInstance: ImageAPIService?
    
    // MARK: - Initializations Methods
    private init() {}
    
    static func getSharedInstance() -> ImageAPIService {
        guard let checkedSharedInstance = self.sharedInstance else {
            let newInstance = ImageAPIService()
            self.sharedInstance = newInstance
            
            return newInstance
        }
        
        return checkedSharedInstance
    }
    
    func getMovieImage(show: Show, completion: (()->())?) {
        if show.image == nil {
            let path: String?
            let type: ImageType
            if let posterPath = show.posterPath {
                path = posterPath
                type = .Poster
            } else if let backdropPath = show.backdropPath {
                path = backdropPath
                type = .Backdrop
            } else {
                completion?()
                return
            }
            if let path = path {
                DispatchQueue.global().async {
                    let url: URL?
                    switch type {
                    case .Poster:
                        url = URL(string: "\(APIConstants.baseImageUrl)\(APIConstants.posterMinimumWidth)\(path)")
                    case .Backdrop:
                        url = URL(string: "\(APIConstants.baseImageUrl)\(APIConstants.backdropMinimumWidth)\(path)")
                    }
                    if let url = url {
                        let request = URLRequest(url: url)
                        URLSession.shared.dataTask(with: request) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let imageData = data, let image = UIImage(data: imageData) {
                                    print("\(show.title)")
                                    show.image = image
                                } else if let error = error {
                                    print("\(show.title) error: \(error.localizedDescription)")
                                } else {
                                    print("\(show.title) NAO SEIIIII")
                                }
                                completion?()
                            }
                        }.resume()
                    } else {
                        completion?()
                    }
                }
            } else {
                completion?()
            }
        }
    }
}
