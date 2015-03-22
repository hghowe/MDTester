//
//  Movie.swift
//  MDTester
//
//  Created by Harlan.Howe on 3/22/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject {

    @NSManaged var date: Int16
    @NSManaged var title: String

    override var description: String
    {
        return "\(title):(\(Int(date)))"
    }
    
}
