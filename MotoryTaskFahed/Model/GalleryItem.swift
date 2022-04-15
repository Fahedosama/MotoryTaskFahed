//
//  GalleryItem.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import Foundation

class GalleryItem : Codable{
    //this model is for the gallery item info
    var id : String = ""
    
    var created_at : String = ""
    
    var description : String? = ""
    var alt_description : String? = ""
    
    var urls = ImagesUrl()
    
    var user = User()
    
    var isFavorite :Bool = false
    
    init() {
        
    }
    
    //make gallery item from coredata
    init(coreData : GalleryItemCoreData){
        self.id = coreData.id
        self.created_at = coreData.created_date
        let user = User()
        user.username = coreData.desc
        user.bio = coreData.alt_desc
        self.user = user
        let url_image = ImagesUrl()
        url_image.small = coreData.image_url_small
        url_image.thumb = coreData.image_url_thumb
        self.urls = url_image
        self.isFavorite = true
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, created_at,urls,user
    }
}
