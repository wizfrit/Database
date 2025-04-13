# Database Systems Assignment 2

## Description
This repository contains the SQL scripts for Assignment 2 of the Database Systems course (Spring Semester 2024). The assignment involves working with a simplified Pinterest database schema, performing nested SQL queries, creating views, and implementing triggers.

## Schema Overview
The database consists of the following tables:
- **Users**: Stores user information (UserID, Name, Gender, Birth Date, Email).
- **Boards**: Represents boards created by users (BoardID, UserID, Name).
- **Pins**: Contains pins associated with boards (PinID, BoardID, Info, URL, Date).
- **Comments**: Stores comments made by users on pins (CommentID, PinID, UserID, Text, Date).
- **Likes**: Tracks likes given by users to pins (PinID, UserID).

## Files
- `l226991_Assignment2.sql`: The main SQL script containing table definitions, data insertion, queries, views, and triggers.
- `Assignment 2 Advanced Nested SQL updated.pdf`: The assignment instructions and requirements.

## Queries
The SQL script includes solutions for the following tasks:
1. **Nested SQL Queries**:
   - a. Print the names of users with the most pins.
   - b. For each PIN with more than 10 likes, print the PIN name and total likes.
   - c. List PIN names for each board, including boards with no pins (null).
   - d. Print PIDs of pins with equal numbers of likes and comments.
   - e. Print details of users who liked all pins made by UserID=100.
   - f. Find pairs of users who commented on the same pins.
   - g. Print names and ages of users older than the average age.
   - h. Print the BoardID with the minimum pins in 2022.
   - i. Find the top 3 boards with the highest number of pins.
   - j. Find names of users who commented on one or more pins.
   - k. List names of boards with exactly five pins.

2. **Views**:
   - `UserBoardsView`: Lists users and their boards.
   - `PopularPinsView`: Displays pin popularity based on likes.
   - `UserActivityView`: Shows user comments and associated pin details.
   - `BoardDetailsView`: Provides board details, pin names, and like counts for boards with over 10 pins.

3. **Triggers**:
   - `NewPinTrigger`: Logs new pin creations in `PinActivityLog`.
   - `PINLikesTrigger`: Prints a message when a pin receives over 100,000 likes.

## Usage
1. Execute the SQL script in a database management system (e.g., MySQL, PostgreSQL) to create the schema, insert data, and run the queries.
2. Review the results of the queries and views as specified in the assignment.

## Notes
- Ensure your database system supports the SQL syntax used in the script.
- The script includes sample data for testing purposes. Modify or extend it as needed for further analysis.

## Submission
Submitted as a zip file to Google Classroom, containing the SQL script and PDF instructions.
