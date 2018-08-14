//
//  ImageAPIService.swift
//  TraktApp
//
//  Created by Yasmin Benatti on 2018-08-14.
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
    
    func getMovieImage(show: Show) {
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
                        guard let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
                            return
                        }
                        show.image = image
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .ShowImageFinishDownload, object: nil, userInfo: [NotificationKeys.tmdbId: show.tmdbId])
                        }
                    }
                }
            }
        }
    }
}
