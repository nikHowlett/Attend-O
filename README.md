# Attend-O

This repository contains all of the source code (with the exception of necessary dependency installs) for the iPhone application portion of the Attend-O automated attendance solution.

##Release Notes
Current Release: 0.4

###Software Features
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
* Front-facing REST API
 * Courses - retrieves a list of the user's (instructor or student) courses
 * CoursePrompt - takes TSquare Labels and dynamically finds section information while also caching course objects
 * StudentSetup - creates a student in the Attend-O system
 * Check-In - validates a students location/request time for a given class and records their attendance
 * AttendanceData - retrieves all of the attendance records for a given student (Queryable by class)
 * mock/locationData - method for retrieving location (should be replaced by RNOC location API)
 * InstructorSetup - creates an instructor in the Attend-O System
 * Summary - retrieves a summary of the attendance records for a given course
 * CreateRequest - create a change of attendance request
 * ViewRequests - get all of the change of attendance requests for a given user
 * RemoveRequest - delete a given change of attendance request
 * AcceptRequest - accept a change of attendance request
* Attend-O Web Client
 * Login
 * Student Setup and Dynamic Course Selection
 * Student Course View
 * Student Attendance View, Check-In, and Request Creation
 * Instructor Course View and User Selection
 * Instructor User Attendance Editor
* Promise-based Utility System
 * Term Selection
 * Object Validation
 * Date/Timezone Operations
 * Course Creation and Storage
 * Course Querying
 * User Querying and Permissions Validation
 
###Bug Fixes from last release
* Attendance editor automatically updates in calendar view
* Course Object Retrieval hits cache before parsing Coursesat.tech
* Permission Validation for users and instructors
* Timezone storage issue for attendance records
* Implemented promise architecture to remove several layered nested callbacks
* Fixed Date Validation Defect for Check-In
* Implemented a try-catch system around Tsquare label parsing for error handling
* Added flexiblity to Tsquare label parsing through additional character lookup

###Know Bugs and Defects
* Difficulty parsing classes with irregular titles, was fixed in previous release but was over-written in github merge conflict
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
 * Try running "npm install" with administrative priveledges
* Running "node server" yields a MongoDB exception and none of the requests are working properly...
 * This is most likely because you do not have a copy of the database configuration file, please send an email to the address stated above.
* How do I know if the server is running
 * The command window hanging after "node server" is a good first indication
 * Then open a browser and type: localhost:8080/api/mock/locationData , this should return a mock location string, if you get this then the application is working properly
* How do I find the web client
 * Open a browser and type localhost:8080, the angular module should direct your browser to the login screen if the server is running
