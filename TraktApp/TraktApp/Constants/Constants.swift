//
//  Constants.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

struct Spacing {
    static let collectionViewSpace: CGFloat = 8.0
}

struct APIConstants {
    static let baseUrl = "https://api.trakt.tv/"
    static let popularUrl = "shows/popular"
}

struct APIShowKey {
    static let title = "title"
    static let ids = "ids"
    static let tmdb = "tmdb"
}

struct ImageConstants {
    static let imagePlaceholder: UIImage? = UIImage(named: "image_placeholder")
}
