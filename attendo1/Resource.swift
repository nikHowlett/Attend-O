//
//  Resource.swift
//  T-Squared for Georgia Tech
//
//  Created by Cal on 9/4/15.
//  Copyright © 2015 Cal Stephens. All rights reserved.
//

import Foundation

class Resource {
    
    let name: String
    let link: String
    
    init(name: String, link: String) {
        self.name = name
        self.link = link
    }
    
}

class ResourceFolder : Resource {
    
    let collectionID: String
    let navRoot: String
    var resourcesInFolder: [Resource]? = nil
    
    init(name: String, link: String, collectionID: String, navRoot: String) {
        self.collectionID = collectionID
        self.navRoot = navRoot
        super.init(name: name, link: link)
    }
    
}