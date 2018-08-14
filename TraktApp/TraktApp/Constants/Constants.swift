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
    static let TMDBKey = "26f127bcbe4fbea0e054b325d0821f1b"
    static let traktKey = "160a6d11fe82aff8bb03d8db5581c82b1a04aa429d579e6646a2e50a82bc997e"
    static let baseTMDBUrl = "https://api.themoviedb.org/3/"
    static let tvRequestTMDB = "tv/"
    static let baseUrl = "https://api.trakt.tv/"
    static let popularUrl = "shows/popular"
    static let baseImageUrl: String = "https://image.tmdb.org/t/p/"
    static let posterMinimumWidth: String = "w92"
    static let backdropMinimumWidth: String = "w300"
}

struct APIShowKey {
    static let title = "title"
    static let ids = "ids"
    static let tmdb = "tmdb"
}

struct APIParameters {
    static let apiKey: String = "api_key"
}

struct ImageConstants {
    static let imagePlaceholder: UIImage? = UIImage(named: "image_placeholder")
}

struct ShowTMDBConstants {
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

struct AlertMessages {
    static let cantLoadShows = "The most poopular shows can't be loaded"
    static let cantLoadShowsSubtitle = "I'm sorry :("
    static let ok = "Ok"
}
