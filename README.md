# Attend-O
Attendace made easy with a Teacher/Student attendance app
# Attend-O

This repository contains all of the source code (with the exception of necessary dependency installs) for the iPhone application portion of the Attend-O automated attendance solution.

##Release Notes
Current Release: 0.4

###Software Features
* iOS app, currently only supporting student features, but to support teacher side before 1.0
* Allows students to use existing CAS login system from Georgia Tech to automatically register attendance
* Provides a section set-up, signing up students for approrpriate classes
* Provides a calendar interface for students to view previous attendance, as well as the ability to dispute events.


###Per page features:
* Login 
 * Use Georgia Tech CAS system to log into Attend-O
 * Alerts if wrong password
 * If correct password, decides to set up courses and sections (First Time Setup) or go automatically to courses
* First Time Setup (will be removed in version 1.0)
 * Pull current enrolled courses and suggested sections (if any) from worksite setup on T-Square
 * Allow users to click on each class and choose correct section
 * In demo mode currently, press Save CRNS, wait 5 seconds, press Save Classes, wait 5 seconds, and then press Transition
* Classes View
 * IF classes and name are sample data, press reload table (will be removed before 1.0)
 * Else, click on any class to see more on Calendar View
* Calendar View
 * Ability to check into class by pressing Check In
 * Ability to chance location (Waiting to work on RNOC location API)

 
###Bug Fixes from last release
* Fixed transition from first time registration to class

###Known Bugs and Defects
* Difficulty parsing classes with irregular titles, was fixed in previous release but was over-written in github merge conflict
* Pressing login button twice will cause login not to work
* First check on correct class returns not attended, but second works
* Classes view needs refresh to load classes as of now
* Location Data is not available from RNOC yet, so mock data is being utilized
* Need for token-based authentication system to validate requests and the information they query

##Install Guide
###Prerequisites
* Xcode 7.3
* Swift command line tools
* CocoaPods or similar package depency installer
* Nik Howlett Development Team Profile Key (please email: nikhowlett@gmail.com)

###Dependent Libraries (See Podfile)
* Pods: 
* MJCalendar
* HexColors
* Ji
* NSDate-Escort
* Alamofire
* SwiftHTTP
* Kanna
* SwiftyJSON

###Download, Setup, and Run Instructions
* Developers
 * Clone this repository
 * Open a command window and navigate to the main folder (containing Podfile), then run "pod install"
 * Now open "attendo1.xcworkspace", set the scheme (top-left, to the right of Stop/Play buttons) to attendo1, and deploy to either simulator or iOS device.
* Users
 * In the future, download from approrpraite App Store

###Troubleshooting
* Installation Issues
 * Ensure that pods are correctly installed, and that you have replaced missing files (will need a few networking files from me for security reasons, nikhowlett@gmail.com)
