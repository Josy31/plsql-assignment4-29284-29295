SET SERVEROUTPUT ON;

-- SUCCESS TESTS
-- Temporary test data will be rolled back after execution.

SAVEPOINT success_test_start;

BEGIN
    DBMS_OUTPUT.PUT_LINE('STUDENT REGISTRATION SYSTEM');
    DBMS_OUTPUT.PUT_LINE('===========================');

    -- TEST 1: Register a new student
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 1: REGISTER STUDENT');

    register_student(
        'TST9001',
        'Test',
        'Student',
        'tst9001@example.com'
    );

    -- TEST 2: Enroll the student in a course
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 2: ENROLL STUDENT');

    enroll_student('TST9001', 'BIT101');

    -- TEST 3: Record the student's grade
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 3: RECORD GRADE');

    record_grade('TST9001', 'BIT101', 88);

    -- TEST 4: Test letter grade function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 4: LETTER GRADE FUNCTION');

    DBMS_OUTPUT.PUT_LINE(
        '88 marks = ' || get_letter_grade(88)
    );

    -- TEST 5: Test student average function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TEST 5: STUDENT AVERAGE FUNCTION');

    DBMS_OUTPUT.PUT_LINE(
        'TST9001 average = ' || get_student_average('TST9001')
    );

    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'ALL SUCCESS TESTS COMPLETED.');

    -- Remove temporary test data
    ROLLBACK TO success_test_start;

    DBMS_OUTPUT.PUT_LINE(
        'Temporary test data rolled back successfully.'
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO success_test_start;
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: ' || SQLERRM);
        RAISE;
END;
/