CREATE OR REPLACE FUNCTION get_student_average (
    p_student_number IN students.student_number%TYPE
)
RETURN NUMBER
AS
    v_average NUMBER(5,2);
BEGIN
    SELECT AVG(g.marks)
    INTO v_average
    FROM students s
    JOIN registrations r
        ON s.student_id = r.student_id
    JOIN grades g
        ON r.registration_id = g.registration_id
    WHERE s.student_number = p_student_number;

    RETURN v_average;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20010,
            'Student does not exist.'
        );
END;
/
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'STU001 Average: ' || get_student_average('STU001')
    );

    DBMS_OUTPUT.PUT_LINE(
        'STU008 Average: ' || get_student_average('STU008')
    );
END;
/
CREATE OR REPLACE FUNCTION get_student_average (
    p_student_number IN students.student_number%TYPE
)
RETURN NUMBER
AS
    v_student_id students.student_id%TYPE;
    v_average NUMBER(5,2);
BEGIN
    -- Confirm that the student exists
    SELECT student_id
    INTO v_student_id
    FROM students
    WHERE student_number = p_student_number;

    -- Calculate the student's average marks
    SELECT NVL(AVG(g.marks), 0)
    INTO v_average
    FROM registrations r
    LEFT JOIN grades g
        ON r.registration_id = g.registration_id
    WHERE r.student_id = v_student_id;

    RETURN v_average;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20010,
            'Student does not exist.'
        );
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'STU001 Average: ' || get_student_average('STU001')
    );
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'STU010 Average: ' || get_student_average('STU010')
    );
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'Average: ' || get_student_average('STU999')
    );
END;
/
