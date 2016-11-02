//
//  TSReader.swift
//  T-Squared for Georgia Tech
//
//  Created by Cal on 8/27/15.
//  Copyright © 2015 Cal Stephens. All rights reserved.
//

import Foundation
import Kanna

let TSInstallDateKey = "edu.gatech.cal.appInstallDate"
let TSLastLoadDate = "edu.gatech.cal.lastLoadDate"

class TSReader {
    
    
    //MARK: - Creating the TSAuthenticatedReader
    
    let username: String
    let password: String
    var initialPage: HTMLDocument? = nil
    var actuallyHasNoClasses = false
    var sectioniers: [String] = []
    
    init(username: String, password: String, initialPage: HTMLDocument?) {
        self.username = username
        self.password = password
        self.classes = nil
        self.initialPage = initialPage
    }
    
    static func authenticatedReader(user user: String, password: String, isNewLogin: Bool, completion: (TSReader?) -> ()) {
        Authenticator.authenticateWithUsername(user, password: password, completion: { success, response in
            completion(success ? TSReader(username: user, password: password, initialPage: response) : nil)
        })
        
        //check if this is first time logging in
        let data = NSUserDefaults.standardUserDefaults()
        if data.valueForKey(TSInstallDateKey) == nil || isNewLogin {
            data.setValue(NSDate(), forKey: TSInstallDateKey)
        }
    }
    
    
    //MARK: - Loading Classes
    
    var classes: [Class]?
    func getActiveClasses() -> [Class] {
        
        guard let doc = initialPage ?? HttpClient.contentsOfPage("https://t-square.gatech.edu/portal/pda/") else {
            initialPage = nil
            return []
        }
        var strings: [String] = []
        var classes: [Class] = []
        var saveLinksAsClasses: Bool = false
        
        defer {
            if classes.count > 0 {
                Class.updateShotcutItemsForActiveClasses(classes)
            }
            self.initialPage = nil
        }
        
        for link in doc.css("a, link") {
            if let rawText = link.text {
                let text = rawText.cleansed()
                if text.containsString("-") {
                    var sectionz = text.componentsSeparatedByString("-")
                    if sectionz.count > 1 {
                        print("SECTIONS KINDA WORKING")
                        var labelz = sectionz[2]
                        var bahd = labelz
                        if labelz.containsString(",") {
                            print("JID EDGE CASE")
                            var loopuj = labelz.componentsSeparatedByString(",")
                            bahd = loopuj[0]
                        }
                        print("below badh")
                        print(bahd)
                        strings.append(bahd)
                    }
                    
                }
                //class links start after My Workspace tab
                if !saveLinksAsClasses && text == "My Workspace" {
                    saveLinksAsClasses = true
                }
                
                else if saveLinksAsClasses {
                    //find the end of the class links
                    if text == "" || text.hasPrefix("\n") || text == "Switch to Full View" {
                        break
                    }
                    
                    //show the short-form name unless there would be duplicates
                    let newClass = Class(fromElement: link)
                    newClass.isActive = true
                    for otherClass in classes {
                        if otherClass.name.hasPrefix(newClass.name) {
                            newClass.useFullName()
                            otherClass.useFullName()
                        }
                    }
                    classes.append(newClass)
                }
            }
        }
        
        self.classes = classes
        sectioniers = strings
        return classes
    }
    func getActiveSections() -> [String] {
        return sectioniers
        /*
        guard let doc = initialPage ?? HttpClient.contentsOfPage("https://t-square.gatech.edu/portal/pda/") else {
            initialPage = nil
            return []
        }
        
        var classes: [Class] = []
        var strings: [String] = []
        var saveLinksAsClasses: Bool = false
        
        defer {
            if classes.count > 0 {
                Class.updateShotcutItemsForActiveClasses(classes)
            }
            self.initialPage = nil
        }
        
        for link in doc.css("a, link") {
            if let rawText = link.text {
                let text = rawText.cleansed()
                if text.containsString("-") {
                    var sectionz = text.componentsSeparatedByString("-")
                    if sectionz.count > 1 {
                        print("SECTIONS KINDA WORKING")
                        var labelz = sectionz[2]
                        var bahd = labelz
                        if labelz.containsString(",") {
                            print("JID EDGE CASE")
                            var loopuj = labelz.componentsSeparatedByString(",")
                            bahd = loopuj[0]
                        }
                        strings.append(bahd)
                    }
                    
                }
                
                //class links start after My Workspace tab
                if !saveLinksAsClasses && text == "My Workspace" {
                    saveLinksAsClasses = true
                }
                    
                else if saveLinksAsClasses {
                    //find the end of the class links
                    if text == "" || text.hasPrefix("\n") || text == "Switch to Full View" {
                        break
                    }
                    
                    //show the short-form name unless there would be duplicates
                    let newClass = Class(fromElement: link)
                    newClass.isActive = true
                    for otherClass in classes {
                        if otherClass.name.hasPrefix(newClass.name) {
                            newClass.useFullName()
                            otherClass.useFullName()
                        }
                    }
                    classes.append(newClass)
                }
            }
        }
        return strings*/
    }
    
    func checkIfHasNoClasses() {
        
        //the thought process here is that the list of classes goes between "My Workspace" and "Switch to Full View".
        //if those two are sequential, then there are no classes.
        
        guard let doc = initialPage ?? HttpClient.contentsOfPage("https://t-square.gatech.edu/portal/pda/") else { return }
        let links = doc.css("a, link")
        let count = links.underestimateCount()
        let anchorLinks = [
            ("Log Out", count - 3),
            ("My Workspace", count - 2),
            //classes normally go here
            ("Switch to Full View", count - 1)
        ]
        
        var hasClasses = false
        
        for (text, index) in anchorLinks {
            if index < 0 {
                hasClasses = true
                break
            }
            
            let actual = links[index].text?.cleansed() ?? ""
            if text != actual {
                hasClasses = true
                break
            }
        }
        
        self.actuallyHasNoClasses = !hasClasses
    }
    
    var allClassesCached: (classes: [Class], preferencesLink: String?)?
    func getAllClasses() -> (classes: [Class], preferencesLink: String?) {
        
        guard let doc = HttpClient.contentsOfPage("https://t-square.gatech.edu/portal/pda/") else { return (classes ?? [], nil) }
        
        for workspaceLink in doc.css("a, link") {
            if workspaceLink["title"] != "My Workspace" { continue }
            guard let workspaceURL = workspaceLink["href"] else { return (classes ?? [], nil) }
            
            guard let workspace = HttpClient.contentsOfPage(workspaceURL) else { return (classes ?? [], nil) }

            for worksiteLink in workspace.css("a, link") {
                if !"Worksite Setup Membership".containsString(worksiteLink["title"] ?? "x") { continue }
                guard let worksiteURL = worksiteLink["href"]?.stringByReplacingOccurrencesOfString("tool-reset", withString: "tool") else { continue }
                
                //find preferencesLink
                var preferencesLink: String?
                for link in workspace.css("a, link") {
                    if link["title"] != "Preferences" { continue }
                    if let mainPreferencesLink = link["href"],
                       //pull from the page's form
                       let mainPreferencesPage = HttpClient.contentsOfPage(mainPreferencesLink) {
                        
                        let forms = mainPreferencesPage.css("form")
                        if forms.underestimateCount() > 0 {
                            preferencesLink = forms[0]["action"]?.stringByReplacingOccurrencesOfString("/tool-reset/", withString: "/tool/")
                        }
                    }
                }
                
                guard let worksite = HttpClient.getPageWith100Count(worksiteURL) else { return (classes ?? [], preferencesLink) }
                
                var allClasses: [Class] = []
                
                for header in worksite.css("h4") {
                    let links = header.css("a, link")
                    if links.underestimateCount() == 0 { continue }
                    let classLink = links[links.underestimateCount() - 1]
                    
                    let className = classLink.text?.cleansed() ?? "Unnamed Class"
                    if className == "My Workspace" { continue }
                    
                    //show the short-form name unless there would be duplicates
                    let newClass = Class(fromElement: classLink)
                    for otherClass in allClasses {
                        if otherClass.name.hasPrefix(newClass.name) {
                            newClass.useFullName()
                            otherClass.useFullName()
                        }
                    }
                    
                    //check if this class is an active class
                    if self.classes == nil { self.getActiveClasses() }
                    if let activeClasses = self.classes where activeClasses.contains(newClass) {
                        newClass.isActive = true
                    }
                    
                    allClasses.append(newClass)
                    
                    //kick off the process to download the class's specific subject name
                    dispatch_async(TSNetworkQueue) {
                        newClass.pullSpecificSubjectNameIfNotCached()
                    }
                }
                
                self.allClassesCached = (allClasses, preferencesLink)
                return (allClasses, preferencesLink)
            }
        }
        
        return (classes ?? [], nil)
    }
    
    func getSpecificSubjectNameForClass(currentClass: Class) -> String? {
        guard let classPage = currentClass.getClassPage() else { return nil }
        
        //load page for class information display
        for link in classPage.css("a, link") {
            if link.text != "Site Information Display" { continue }
            
            guard let url = link["href"] else { continue }
            guard let page = HttpClient.contentsOfPage(url) else { return nil }
            
            for div in page.css("div") {
                if div["class"]?.containsString("siteDescription") == true {
                    let text = div.text?.stringByReplacingOccurrencesOfString("\n", withString: " ").cleansed()
                    
                    //sometimes there's a paragraph of text instead of just the subject name
                    //try to filter those out
                    let wordCount = text?.componentsSeparatedByString(" ").count ?? 0
                    if wordCount >= 10 {
                        return nil
                    }
                    
                    if text?.containsString("--NO TITLE--") == true {
                        return nil
                    }
                    
                    if text?.lowercaseString.containsString("welcome") == true {
                        return nil
                    }
                    
                    return text
                }
            }
        }
        
        return nil
    }
    
    
    //MARK: - Loading Announcements
    
    func getAnnouncementsForClass(currentClass: Class, loadAll: Bool = false) -> [Announcement] {
        guard let classPage = currentClass.getClassPage() else { return [] }
        
        var announcements: [Announcement] = []
        
        //load page for class announcements
        for link in classPage.css("a, link") {
            if link.text != "Announcements" { continue }
            guard let announcementsURL = link["href"] else { continue }
            
            var announcementsPageOpt: HTMLDocument?
            if !loadAll {
                announcementsPageOpt = HttpClient.contentsOfPage(announcementsURL)
            }
            else {
                announcementsPageOpt = HttpClient.getPageWith100Count(announcementsURL)
            }
            
            guard let announcementsPage = announcementsPageOpt else { return [] }
            
            //load announcements
            for row in announcementsPage.css("tr") {
                let links = row.css("a")
                if links.underestimateCount() == 1 {
                    
                    guard let link = links[0]["href"] else { continue }
                    let name = links[0].text?.cleansed() ?? "Untitled Announcement"
                    var author: String = ""
                    var date: String = ""
                    
                    for col in row.css("td") {
                        if let header = col["headers"] {
                            let text = col.text?.cleansed() ?? "Could not load message."
                            switch(header) {
                                case "author": author = text; break;
                                case "date": date = text; break;
                                default: break;
                            }
                        }
                    }
                    
                    let announcement = Announcement(inClass: currentClass, name: name, author: author, date: date, link: link)
                    announcements.append(announcement)
                }
            }
            
            currentClass.announcements = announcements
            return announcements
        }
        
        return announcements
    }
    
    
    //MARK: - Loading Resources
    
    func getResourcesInRoot(currentClass: Class) -> [Resource] {
        if let root = getResourceRootForClass(currentClass) {
            return getResourcesInFolder(root)
        }
        return []
    }
    
    func getResourceRootForClass(currentClass: Class) -> ResourceFolder? {
        
        if let root = currentClass.rootResource {
            return root
        }
        
        guard let classPage = currentClass.getClassPage() else { return nil }
        //load page for resources
        for link in classPage.css("a, link") {
            if link.text != "Resources" { continue }
            guard let linkURL = link["href"] else { continue }
            let root = ResourceFolder(name: "Resources in \(currentClass.name)", link: linkURL, collectionID: "", navRoot: "")
            currentClass.rootResource = root
            return root
        }
        
        return nil
    }
    
    func getResourcesInFolder(folder: ResourceFolder) -> [Resource] {
        var resources: [Resource] = []
        //load resources if they haven't been already
        guard let resourcesPage = HttpClient.getPageForResourceFolder(folder) else { return resources }
        
        for row in resourcesPage.css("h4") {
            let links = row.css("a")
            if links.underestimateCount() == 0 { continue }
            var resourcesLink = links[links.underestimateCount() - 1]
            
            if let javascript = resourcesLink["onclick"] {
                let collectionID = HttpClient.getInfoFromPage(javascript as NSString, infoSearch: "'collectionId').value='", terminator: "'")!
                let navRoot = HttpClient.getInfoFromPage(javascript as NSString, infoSearch: "'navRoot').value='", terminator: "'")!
                let name = (resourcesLink.text ?? "Unnamed folder").cleansed()
                let folder = ResourceFolder(name: name, link: folder.link, collectionID: collectionID, navRoot: navRoot)
                resources.append(folder)
            }
            else {
                //find a link with actual content
                var linkOffset = 2
                while resourcesLink["href"] == "#" && linkOffset < (links.underestimateCount() + 1) {
                    resourcesLink = links[max(0, links.underestimateCount() - linkOffset)]
                    linkOffset += 1
                }
                
                //we didn't find anything useful. bail out.
                if resourcesLink["href"] == "#" { continue }
                
                if let resourcesLinkURL = resourcesLink["href"] {
                    let name = resourcesLink.text ?? "Unnamed Resource"
                    let resource = Resource(name: name.cleansed(), link: resourcesLinkURL)
                    resources.append(resource)
                }
            }
            
        }
        
        folder.resourcesInFolder = resources
        return resources
    }
    
    
    //MARK: - Loading Assignments
    
    func getAssignmentsForClass(currentClass: Class) -> [Assignment] {
        guard let classPage = currentClass.getClassPage() else { return [] }
        
        var assignments: [Assignment] = []
        
        //load page for class assignments
        for link in classPage.css("a, link") {
            if link.text != "Assignments" { continue }
            guard let linkHref = link["href"] else { return [] }
            guard let assignmentsPage = HttpClient.getPageWith100Count(linkHref) else { return [] }
            
            //load assignments
            for row in assignmentsPage.css("tr") {
                let links = row.css("a")
                if links.underestimateCount() == 1 {
                    
                    guard let link = links[0]["href"] else { continue }
                    let name = (links[0].text ?? "Untitled Assignment").cleansed()
                    var statusString: String = ""
                    var dueDateString: String = ""
                    
                    for col in row.css("td") {
                        if let header = col["headers"], let text = col.text?.cleansed() {
                            switch(header) {
                                case "dueDate": dueDateString = text; break;
                                case "status": statusString = text; break;
                                default: break;
                            }
                        }
                    }
                    
                    let complete = statusString != "Not Started" && statusString != ""
                    let assignment = Assignment(name: name, link: link, dueDate: dueDateString, completed: complete, inClass: currentClass)
                    assignments.append(assignment)
                }
            }
            currentClass.assignments = assignments
            return assignments
        }
        
        return assignments
    }
    
    
    //MARK: - Loading Grades  
    
    
    func addFlatGradeListToRoot(rootGroup: GradeGroup, inClass currentClass: Class, groups: [GradeGroup], grades: [Grade]) {
        
        for group in groups {
            rootGroup.scores.append(group)
            group.owningGroup = rootGroup
        }
        
        for grade in grades {
            let groupName = grade.owningGroupName ?? "ROOT"
            var group: GradeGroup?
            
            if groupName == "ROOT" {
                group = rootGroup
            } else  {
                for score in rootGroup.scores {
                    if let currentGroup = score as? GradeGroup where currentGroup.name.lowercaseString == groupName.lowercaseString {
                        group = currentGroup
                        break
                    }
                }
            }
            
            group?.scores.append(grade)
            grade.owningGroup = group
            grade.performDropCheckWithClass(currentClass)
        }
        
    }
    
    
    //MARK: - Getting Resource for Syllabus
    
    func getSyllabusURLForClass(currentClass: Class) -> (syllabusPage: String?, document: String?) {
        
        guard let classPage = currentClass.getClassPage() else { return (nil, nil) }
        //load page for class announcements
        for link in classPage.css("a, link") {
            if link.text != "Syllabus" { continue }
            guard let syllabusLink = link["href"] else { return (nil, nil) }
            guard let syllabusPage = HttpClient.contentsOfPage(syllabusLink) else { return (nil, nil) }
            
            //check if the syllabus is hiding in an iframe
            let iframes = syllabusPage.css("iframe")
            if iframes.underestimateCount() > 0 {
                let iframe = iframes[0]
                if let src = iframe["src"] {
                    return (syllabusLink, src)
                }
            }
            
            let ignore = ["Sites", "?", "Log Out", "Switch to Full View", "", currentClass.fullName]
            var notIgnore: XMLElement? = nil
            
            for link in syllabusPage.css("a") {
                if let linkText = link.text?.cleansed() where !ignore.contains(linkText) {
                    //not a link to ignore
                    if notIgnore == nil { notIgnore = link }
                    else { return (syllabusLink, nil) } //multiple links worth keeping, won't pick and choose
                }
            }
            return (syllabusLink, notIgnore?["href"])
        }
        return (nil, nil)
    }
    
}

extension String {
    
    func dateWithTSquareFormat() -> NSDate? {
        //convert date string to NSDate
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        //correct formatting to match required style
        //(Aug 27, 2015 11:27 am) -> (Aug 27, 2015, 11:27 AM)
        var dateString = self.stringByReplacingOccurrencesOfString("pm", withString: "PM")
        dateString = dateString.stringByReplacingOccurrencesOfString("am", withString: "AM")
        
        for year in 1990...2040 { //add comma after years
            dateString = dateString.stringByReplacingOccurrencesOfString("\(year) ", withString: "\(year), ")
        }
        return formatter.dateFromString(dateString)
    }
    
}

