//
//  Class.swift
//  attendo1
//
//  Created by Nik Howlett on 11/7/15.
//  Copyright (c) 2015 NikHowlett. All rights reserved.
//

import Foundation
import CoreData
@objc(Class2)

class Class2: NSManagedObject {
    
    @NSManaged var courseName: String
    @NSManaged var startTime: NSDate
    
}
