//
//  GalleryItemCoreData.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import Foundation
import CoreData

// 1
@objc(GalleryItemCoreData)
// 2
final class GalleryItemCoreData: NSManagedObject {
    // 3
    @NSManaged var id: String
    @NSManaged var desc: String
    @NSManaged var alt_desc: String
    @NSManaged var created_date: String
    @NSManaged var image_url_small: String
    @NSManaged var image_url_thumb: String
}

extension GalleryItemCoreData {
    // 4
    @nonobjc class func fetchRequest() -> NSFetchRequest<GalleryItemCoreData> {
        return NSFetchRequest<GalleryItemCoreData>(entityName: Constants.ENTITY_NAME_COREDATA)
    }
}

