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
    
    func getPopularShows(completion: @escaping (_ shows: [Show]?)->()) {
        Alamofire.request("\(APIConstants.baseUrl)\(APIConstants.popularUrl)", method: .get).responseJSON { (response) in
            guard let valueDict = response.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            var shows: [Show] = []
            for show in valueDict {
                if let show = Show.parse(dict: show) {
                    shows.append(show)
                }
            }
            
            completion(shows)
        }
    }
    
    
    
}
