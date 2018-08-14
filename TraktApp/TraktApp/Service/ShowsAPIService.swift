//
//  ShowsAPIService.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import Alamofire

class ShowsAPIService {
    // MARK: - Variables
    private static var sharedInstance: ShowsAPIService? = nil
    private var maxNumberOfPages: Int = 0
    private var actualPage: Int = 0
    private var isLoading: Bool = false
    // MARK: - Initializations Methods
    private init() {}
    
    static func getSharedInstance() -> ShowsAPIService {
        guard let checkedSharedInstance = self.sharedInstance else {
            let newInstance = ShowsAPIService()
            self.sharedInstance = newInstance
            
            return newInstance
        }
        
        return checkedSharedInstance
    }
    
    func restartPopularShows() {
        self.actualPage = 0
    }
    
    func getPopularShows(completion: @escaping (_ shows: [Show]?)->()) {
        isLoading = true
        actualPage += 1
        let parameters: [String: Any] = [APIParameters.page: actualPage, APIParameters.limit: APIConstants.limitPagination]
        let headers: HTTPHeaders = [APIHeaders.apiKey: APIConstants.traktKey]
        Alamofire.request("\(APIConstants.baseUrl)\(APIConstants.popularUrl)", parameters: parameters, headers: headers).responseJSON { (response) in
            guard let valueDict = response.value as? [[String: Any]], let maxNumberOfPages = response.response?.allHeaderFields[APIHeaders.maxNumberOfPages] as? String else {
                completion(nil)
                return
            }
            if let maxPages = Int(maxNumberOfPages) {
                self.maxNumberOfPages = Int(maxPages)
            }
            
            var shows: [Show] = []
            let dispatchGroup = DispatchGroup()
            for show in valueDict {
                if let show = Show.parse(dict: show) {
                    shows.append(show)
                    dispatchGroup.enter()
                    ShowsAPIService.getSharedInstance().getTMDBShow(show: show) { (success) in
                        if success {
                            dispatchGroup.enter()
                            ImageAPIService.getSharedInstance().getMovieImage(show: show, completion: {
                                dispatchGroup.leave()
                            })
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                self.isLoading = false
                completion(shows)
            })
        }
    }
    
    
    private func getTMDBShow(show: Show, completion: @escaping (_ success: Bool)->()) {
        let parameters: [String: Any] = [APIParameters.apiKey: APIConstants.TMDBKey]
        Alamofire.request("\(APIConstants.baseTMDBUrl)\(APIConstants.tvRequestTMDB)\(show.tmdbId)", method: .get, parameters: parameters).responseJSON { (response) in
            guard let valueDict = response.value as? [String: Any] else {
                completion(false)
                return
            }
            
            if let posterPath = valueDict[ShowTMDBConstants.posterPath] as? String {
                show.posterPath = posterPath
            }
            
            if let backdropPath = valueDict[ShowTMDBConstants.backdropPath] as? String {
                show.backdropPath = backdropPath
            }
            
            completion(true)
        }
        
    }
    
    func canLoadMore() -> Bool {
        return !isLoading && maxNumberOfPages > actualPage
    }
    
    func canPullToRefresh() -> Bool {
        return !isLoading
    }
    
    
}
