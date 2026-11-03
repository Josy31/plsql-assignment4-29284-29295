SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE record_grade (
    p_student_number IN students.student_number%TYPE,
    p_course_code    IN courses.course_code%TYPE,
    p_marks          IN grades.marks%TYPE
)
AS
    v_registration_id registrations.registration_id%TYPE;
    v_letter_grade    grades.letter_grade%TYPE;
    v_result          grades.result%TYPE;

BEGIN

    IF p_marks IS NULL OR p_marks < 0 OR p_marks > 100 THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'Marks must be between 0 and 100.'
        );
    END IF;

    SELECT r.registration_id
    INTO v_registration_id
    FROM registrations r
    JOIN students s
        ON r.student_id = s.student_id
    JOIN courses c
        ON r.course_id = c.course_id
    WHERE s.student_number = p_student_number
      AND c.course_code = p_course_code;

    IF p_marks >= 80 THEN
        v_letter_grade := 'A';
    ELSIF p_marks >= 70 THEN
        v_letter_grade := 'B';
    ELSIF p_marks >= 60 THEN
        v_letter_grade := 'C';
    ELSIF p_marks >= 50 THEN
        v_letter_grade := 'D';
    ELSE
        v_letter_grade := 'F';
    END IF;

    IF p_marks >= 50 THEN
        v_result := 'PASS';
    ELSE
        v_result := 'FAIL';
    END IF;

    INSERT INTO grades (
        registration_id,
        marks,
        letter_grade,
        result
    )
    VALUES (
        v_registration_id,
        p_marks,
        v_letter_grade,
        v_result
    );

    DBMS_OUTPUT.PUT_LINE('GRADE RECORDED SUCCESSFULLY');
    DBMS_OUTPUT.PUT_LINE('Student: ' || p_student_number);
    DBMS_OUTPUT.PUT_LINE('Course: ' || p_course_code);
    DBMS_OUTPUT.PUT_LINE('Marks: ' || p_marks);
    DBMS_OUTPUT.PUT_LINE('Letter Grade: ' || v_letter_grade);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_result);

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20007,
            'Student is not registered in this course, or the student/course does not exist.'
        );

    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(
            -20008,
            'A grade has already been recorded for this student in this course.'
        );

    WHEN OTHERS THEN
        RAISE;

END record_grade;
/


DECLARE

    PROCEDURE test_grade (
        p_test_name VARCHAR2,
        p_student   VARCHAR2,
        p_course    VARCHAR2,
        p_marks     NUMBER
    )
    AS
    BEGIN

        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('TEST: ' || p_test_name);

        BEGIN

            record_grade(
                p_student,
                p_course,
                p_marks
            );

            DBMS_OUTPUT.PUT_LINE('STATUS: SUCCESS');

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('STATUS: ERROR HANDLED');
                DBMS_OUTPUT.PUT_LINE('MESSAGE: ' || SQLERRM);
        END;

    END test_grade;

BEGIN

    test_grade(
        'Duplicate Grade Test',
        'STU008',
        'BIT105',
        85
    );

    test_grade(
        'Invalid Marks Test',
        'STU009',
        'BIT102',
        120
    );

    test_grade(
        'Invalid Student Test',
        'STU999',
        'BIT102',
        75
    );

    test_grade(
        'Invalid Course Test',
        'STU009',
        'BIT999',
        75
    );

    test_grade(
        'Student Not Registered Test',
        'STU001',
        'BIT105',
        75
    );

END;
/

SELECT
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    g.marks,
    g.letter_grade,
    g.result
FROM grades g
JOIN registrations r
    ON g.registration_id = r.registration_id
JOIN students s
    ON r.student_id = s.student_id
JOIN courses c
    ON r.course_id = c.course_id
WHERE s.student_number = 'STU008'
  AND c.course_code = 'BIT105';