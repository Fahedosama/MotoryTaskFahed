//
//  Urls.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import Foundation

class Urls{
    //this class contains all urls info
    static let shared = Urls()
    
    let baseUrl : String = "https://api.unsplash.com"
    
    func getBaseUrl() -> String {
        return baseUrl
    }
    
    //Get a single page from the Editorial feed.
    func getImagesUrl() -> String {
        return getBaseUrl() + "/photos/?client_id=\(Constants.ACCESS_KEY)"
    }
}
