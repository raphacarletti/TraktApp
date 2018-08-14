//
//  Show.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class Show {
    let title: String
    let tmdbId: Int
    var posterPath: String? = nil
    var backdropPath: String? = nil
    var image: UIImage? = nil
    
    init(title: String, tmdbId: Int) {
        self.title = title
        self.tmdbId = tmdbId
    }
}

extension Show {
    static func parse(dict: [String: Any]) -> Show? {
        guard let title = dict[APIShowKey.title] as? String, let ids = dict[APIShowKey.ids] as? [String: Any], let tmdbId = ids[APIShowKey.tmdb] as? Int else {
            return nil
        }
        
        return Show(title: title, tmdbId: tmdbId)
    }
}
