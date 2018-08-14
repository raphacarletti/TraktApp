//
//  Show.swift
//  TraktApp
//
//  Created by Yasmin Benatti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation

class Show {
    let title: String
    let tmdbId: Int
    
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
