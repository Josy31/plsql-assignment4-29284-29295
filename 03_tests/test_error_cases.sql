SET SERVEROUTPUT ON;

-- TEST 1: Duplicate student registration
BEGIN
    DBMS_OUTPUT.PUT_LINE('TEST 1: DUPLICATE STUDENT');

    register_student(
        'STU011',
        'Duplicate',
        'Student',
        'duplicate@example.com'
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 2: Enroll nonexistent student
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 2: NONEXISTENT STUDENT');

    enroll_student('STU999', 'BIT101');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 3: Enroll in nonexistent course
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 3: NONEXISTENT COURSE');

    enroll_student('STU001', 'BIT999');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 4: Duplicate enrollment
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 4: DUPLICATE ENROLLMENT');

    enroll_student('STU008', 'BIT103');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 5: Invalid marks
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 5: INVALID MARKS');

    record_grade('STU009', 'BIT102', 120);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 6: Duplicate grade
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 6: DUPLICATE GRADE');

    record_grade('STU001', 'BIT101', 75);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 7: Student not enrolled in course
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 7: INVALID REGISTRATION');

    record_grade('STU001', 'BIT105', 75);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 8: Invalid letter grade marks
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 8: INVALID FUNCTION INPUT');

    DBMS_OUTPUT.PUT_LINE(
        'Grade: ' || get_letter_grade(120)
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

-- TEST 9: Average for nonexistent student
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 9: NONEXISTENT STUDENT AVERAGE');

    DBMS_OUTPUT.PUT_LINE(
        'Average: ' || get_student_average('STU999')
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXPECTED ERROR: ' || SQLERRM);
END;
/

DBMS_OUTPUT.PUT_LINE(CHR(10) || 'ERROR TESTING COMPLETED.');