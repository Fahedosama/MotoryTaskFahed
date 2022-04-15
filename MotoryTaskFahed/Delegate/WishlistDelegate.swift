//
//  WishlistDelegate.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import Foundation

protocol WishlistDelegate{
    
    //to call from tableview cell wishlist button
    func onWishlistClicked(data : GalleryItem,indexPath : IndexPath)
}
