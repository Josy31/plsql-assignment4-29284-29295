Implementation Notes

Student Registration and Grading System

Database: Oracle Database 21c Express Edition  
Language: Oracle PL/SQL  
Development Environment:Oracle SQL Developer  


1.Implementation Overview

The Student Registration and Grading System was implemented using Oracle SQL and PL/SQL.

The implementation separates database structure, sample data, stored procedures, functions, and test scripts into different directories.

This organization makes the application easier to understand, maintain, test, and extend.

The database uses four related tables:

- STUDENTS
- COURSES
- REGISTRATIONS
- GRADES

Primary keys, foreign keys, unique constraints, and check constraints are used to maintain data integrity.

2. Database Implementation

STUDENTS Table

Stores student identification and contact information.

The student number and email address are unique to prevent duplicate student records.

COURSES Table

Stores course codes, course names, and credit values.

The course code is unique, and the credits column is validated using a check constraint.

REGISTRATIONS Table

Connects students with courses.

Foreign keys ensure that a registration references an existing student and course.

A unique constraint on the student and course combination prevents the same student from registering for the same course more than once.

The registration status is restricted to the supported values:

- ACTIVE
- COMPLETED
- WITHDRAWN

GRADES Table

Stores marks and calculated academic results.

The marks column is restricted to values between 0 and 100.

A unique constraint on REGISTRATION_ID ensures that a registration receives only one grade record.

The letter grade and result columns are also constrained to their permitted values.

3. Records and Collections

%ROWTYPE

The `%ROWTYPE` attribute was used to declare a record with the same structure as a database table row.

For example:

```sql
v_student students%ROWTYPE;
```

This allows the program to retrieve and access all columns of a student record through one variable.

User-Defined Records

A custom record was created to store selected student information, including:

- Student number.
- Full name.
- Email address.

This demonstrates how PL/SQL records can group related values into one structured variable.

Associative Arrays

An associative array was implemented using:

```sql
TYPE student_names_type IS TABLE OF VARCHAR2(100)
INDEX BY PLS_INTEGER;
```

It was used to store student names indexed by integer values.

Nested Tables

A nested table collection was used to store course names dynamically.

The EXTEND method was used to increase the collection size before assigning values.

VARRAY

A VARRAY with a maximum capacity of five elements was used to store marks.

The collection was used to demonstrate collection initialization, element assignment, and calculations such as total and average marks.

4. Cursor Implementation

 Implicit Cursors

Implicit cursors were demonstrated through INSERT, UPDATE, and DELETE operations.

The following attributes were tested:

- SQL%ROWCOUNT
- SQL%FOUND
- SQL%NOTFOUND
- SQL%ISOPEN

A savepoint and rollback were used to prevent temporary test operations from permanently changing the data.

 Explicit Cursors

Explicit cursors were implemented in three ways:

1. Manual cursor handling with OPEN, FETCH, and CLOSE.
2. Cursor FOR loops.
3. A cursor joining STUDENTS, REGISTRATIONS, COURSES, and GRADES.

A LEFT JOIN was used in the registration report so that registrations without grade records could also be displayed.

5. Bulk Processing

Bulk processing was implemented using BULK COLLECT and FORALL.

  BULK COLLECT

BULK COLLECT retrieves multiple rows from a SQL query into PL/SQL collections in one operation.

It was used to retrieve grade identifiers and marks.

  FORALL

FORALL was used to update multiple grade records efficiently.

The grading logic was applied to each retrieved mark.

  Bulk Exception Handling

The SAVE EXCEPTIONS option was used with FORALL to allow bulk processing to continue even when individual DML operations failed.

The predefined exception associated with ORA-24381 was handled.

SQL%BULK_EXCEPTIONS and SQL%BULK_ROWCOUNT were used to inspect successful and failed operations.

The bulk error test included:

- A valid grade insertion.
- A duplicate grade insertion.
- An insertion with invalid marks.
- Another valid grade insertion.

A rollback was used to remove temporary test records.

6. Stored Procedures

  REGISTER_STUDENT

Parameters:
- Student number.
- First name.
- Last name.
- Email address.

Implementation:

The procedure validates required input values and inserts a new student record.

It handles duplicate values using DUP_VAL_ON_INDEX and raises application errors for invalid or duplicate student information.

  ENROLL_STUDENT

Parameters:
- Student number.
- Course code.

Implementation:

The procedure retrieves the student and course identifiers using SELECT INTO statements.

Nested exception-handling blocks distinguish between a missing student and a missing course.

It then inserts a registration record.

Duplicate registrations are prevented and reported using a custom application error.

  RECORD_GRADE

Parameters:
- Student number.
- Course code.
- Marks.

Implementation:

The procedure validates marks and retrieves the registration identifier by joining the STUDENTS, COURSES, and REGISTRATIONS tables.

It calculates the letter grade and pass/fail result before inserting the grade record.

It handles:

- Invalid marks.
- Missing student or course registrations.
- Duplicate grade submissions.

 7. Functions

  GET_LETTER_GRADE

Accepts marks and returns the corresponding letter grade.

The function validates the marks before returning a result.

  GET_STUDENT_AVERAGE

Accepts a student number and calculates the average of all recorded grades for that student.

The function first verifies that the student exists.

NVL is used with AVG so that an existing student without recorded grades receives an average of zero.

A custom application error is raised when the requested student does not exist.

 8. Grading Logic

The application uses the following grading scale:

| Marks | Grade | Result |
|---|---|---|
| 80–100 | A | PASS |
| 70–79 | B | PASS |
| 60–69 | C | PASS |
| 50–59 | D | PASS |
| 0–49 | F | FAIL |

A score of 50 or above is considered a pass.

  9. Exception Handling

The application demonstrates predefined, user-defined, and application exceptions.

     NO_DATA_FOUND

Used when a SELECT INTO statement does not return a matching record.

Examples include missing students and missing courses.

     TOO_MANY_ROWS

Demonstrated by selecting multiple student records into a single scalar variable.

The exception is caught and handled using a dedicated exception handler.

  DUP_VAL_ON_INDEX

Used to handle duplicate values that violate unique constraints.

It is demonstrated in student registration and grade recording.

  User-Defined Exception

The exception `e_invalid_marks` was declared and raised when marks were outside the valid range.

  RAISE_APPLICATION_ERROR

Custom application errors were implemented to provide meaningful error messages.

| Error Code | Meaning |
|---|---|
| -20001 | Required student information is missing |
| -20002 | Student number or email already exists |
| -20003 | Student number does not exist |
| -20004 | Course code does not exist |
| -20005 | Duplicate enrollment |
| -20006 | Invalid marks |
| -20007 | Student is not registered in the specified course, or student/course does not exist |
| -20008 | Grade already recorded |
| -20009 | Invalid marks supplied to GET_LETTER_GRADE |
| -20010 | Student does not exist in GET_STUDENT_AVERAGE |

   Testing Strategy

Testing was separated into dedicated SQL scripts.

The test scripts cover:

- Records.
- Collections.
- Implicit cursors.
- Explicit cursors.
- Bulk processing.
- Exception handling.
- Successful application operations.
- Invalid application operations.

Successful operations were verified through DBMS_OUTPUT and SQL SELECT statements.

Error scenarios were tested to verify that the application raises the expected errors.

Temporary test data was rolled back where appropriate to preserve the original sample data.

     Transaction Management

The application uses Oracle transaction management.

COMMIT makes changes permanent, while ROLLBACK reverses uncommitted changes.

SAVEPOINT was used in test scripts to isolate temporary database operations.

The stored procedures do not issue COMMIT automatically. This allows the calling program or database user to control the transaction.

    Performance and Data Integrity Considerations

The implementation uses:

- Primary keys to uniquely identify records.
- Foreign keys to enforce relationships.
- Unique constraints to prevent duplicate records.
- Check constraints to validate marks, credits, grades, and registration status.
- BULK COLLECT and FORALL to reduce repeated SQL-to-PL/SQL context switching during bulk operations.
- Reusable stored procedures and functions to centralize application logic.

For larger datasets, additional performance improvements could include appropriate indexes, bulk processing with LIMIT for large collections, and execution-plan analysis.

    Limitations and Possible Improvements

The current application focuses on the required PL/SQL concepts and database operations.

Possible future improvements include:

- A web-based user interface.
- Authentication and role-based access control.
- Student transcript generation.
- Course capacity management.
- Grade modification and audit history.
- Reporting dashboards.
- More detailed validation of registration and academic status.

      Conclusion

The implementation demonstrates the practical application of Oracle PL/SQL in a Student Registration and Grading System.

It combines structured database design, records, collections, cursors, bulk processing, stored procedures, functions, and exception handling into one application.