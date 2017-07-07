//
//  ItemType+CoreDataProperties.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/17/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
