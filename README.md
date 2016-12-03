# Attend-O

This repository contains all of the source code (with the exception of the database connection configuration) for the back-end and web front-end of the Attend-O automated attendance solution.

##Release Notes
Current Release: 0.3

###Software Features
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
* Calendar view on web client removes attendance records from view when first loaded and switching months
* Statistics view is not reactive to changing browser sizes
* Location Data is not available from RNOC yet, so mock data is being utilized
* Need for token-based authentication system to validate requests and the information they query
* Need for CAS login and authentication for web-client

##Install Guide
###Prerequisites
* Node Package Manager (NPM)
* NodeJS
* Database Configuration File (please email: mitchell.a.webster@gmail.com)

###Dependent Libraries (See package.json)
* Node Standard Libraries: 
* Async
* Body-Parser
* Mongodb
* Request
* Time
* Promise

###Download, Setup, and Run Instructions
* Developers
 * Clone this repository
 * Open a command window and navigate to the main folder (containing server.js), then run "npm install"
 * Now run "node server", and the server will exist on localhost:8080
* Users
 * This project currently runs on a private IP while it is currently still in development (please email: mitchell.a.webster@gmail.com for more information)

###Troubleshooting
* Installation Issues
 * Ensure that both npm and nodeJS are properly installed on your machine
 * Try running "npm install" with administrative priveledges
* Running "node server" yields a MongoDB exception and none of the requests are working properly...
 * This is most likely because you do not have a copy of the database configuration file, please send an email to the address stated above.
* How do I know if the server is running
 * The command window hanging after "node server" is a good first indication
 * Then open a browser and type: localhost:8080/api/mock/locationData , this should return a mock location string, if you get this then the application is working properly
* How do I find the web client
 * Open a browser and type localhost:8080, the angular module should direct your browser to the login screen if the server is running
