SET SERVEROUTPUT ON;

DECLARE
    v_student_id students.student_id%TYPE;
BEGIN
    SELECT student_id
    INTO v_student_id
    FROM students;

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_student_id);

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'TOO_MANY_ROWS: The query returned more than one student.'
        );
END;
/
SET SERVEROUTPUT ON;

DECLARE
    e_invalid_marks EXCEPTION;
    v_marks NUMBER := 120;
BEGIN
    IF v_marks < 0 OR v_marks > 100 THEN
        RAISE e_invalid_marks;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Marks are valid.');

EXCEPTION
    WHEN e_invalid_marks THEN
        DBMS_OUTPUT.PUT_LINE(
            'USER-DEFINED EXCEPTION: Marks must be between 0 and 100.'
        );
END;
/