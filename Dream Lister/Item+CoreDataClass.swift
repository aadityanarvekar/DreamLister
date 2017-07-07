//
//  Item+CoreDataClass.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/17/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
}
