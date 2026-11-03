CREATE OR REPLACE PROCEDURE enroll_student (

    p_student_number IN students.student_number%TYPE,
    p_course_code    IN courses.course_code%TYPE

)
AS

    v_student_id students.student_id%TYPE;
    v_course_id  courses.course_id%TYPE;

BEGIN

    -- 1. Find the student
    SELECT student_id
    INTO v_student_id
    FROM students
    WHERE student_number = p_student_number;

    -- 2. Find the course
    SELECT course_id
    INTO v_course_id
    FROM courses
    WHERE course_code = p_course_code;

    -- 3. Register the student for the course
    INSERT INTO registrations (
        student_id,
        course_id
    )
    VALUES (
        v_student_id,
        v_course_id
    );

    DBMS_OUTPUT.PUT_LINE(
        'Student ' || p_student_number ||
        ' successfully enrolled in ' || p_course_code
    );

EXCEPTION

    WHEN NO_DATA_FOUND THEN

        RAISE_APPLICATION_ERROR(
            -20003,
            'Student number or course code does not exist.'
        );

    WHEN DUP_VAL_ON_INDEX THEN

        RAISE_APPLICATION_ERROR(
            -20005,
            'This student is already enrolled in this course.'
        );

    WHEN OTHERS THEN

        RAISE;

END;
/

SET SERVEROUTPUT ON;

BEGIN
    enroll_student(
        'STU008',
        'BIT103'
    );
END;
/
SELECT
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    r.status,
    r.enrollment_date
FROM registrations r
JOIN students s
    ON r.student_id = s.student_id
JOIN courses c
    ON r.course_id = c.course_id
WHERE s.student_number = 'STU008'
ORDER BY c.course_code;
SELECT
    s.student_number,
    c.course_code,
    c.course_name,
    r.status
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU008'
ORDER BY c.course_code;
SELECT
    s.student_number,
    c.course_code,
    c.course_name,
    r.status
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU008'
ORDER BY c.course_code;
BEGIN
    enroll_student(
        'STU999',
        'BIT101'
    );
END;
/
SET SERVEROUTPUT ON;

BEGIN
    enroll_student(
        'STU999',
        'BIT101'
    );
END;
/

SET SERVEROUTPUT ON;

BEGIN
    enroll_student(
        'STU001',
        'BIT999'
    );
END;
/

CREATE OR REPLACE PROCEDURE enroll_student (

    p_student_number IN students.student_number%TYPE,
    p_course_code    IN courses.course_code%TYPE

)
AS

    v_student_id students.student_id%TYPE;
    v_course_id  courses.course_id%TYPE;

BEGIN

    -- 1. Find the student
    BEGIN
        SELECT student_id
        INTO v_student_id
        FROM students
        WHERE student_number = p_student_number;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Student number does not exist.'
            );
    END;

    -- 2. Find the course
    BEGIN
        SELECT course_id
        INTO v_course_id
        FROM courses
        WHERE course_code = p_course_code;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20004,
                'Course code does not exist.'
            );
    END;

    -- 3. Register the student
    INSERT INTO registrations (
        student_id,
        course_id
    )
    VALUES (
        v_student_id,
        v_course_id
    );

    DBMS_OUTPUT.PUT_LINE(
        'Student ' || p_student_number ||
        ' successfully enrolled in ' || p_course_code
    );

EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'This student is already enrolled in this course.'
        );

    WHEN OTHERS THEN
        RAISE;

END;
/

BEGIN
    enroll_student('STU999', 'BIT101');
END;
/

SET SERVEROUTPUT ON;

BEGIN
    enroll_student(
        'STU001',
        'BIT999'
    );
END;
/

SELECT line, text
FROM user_source
WHERE name = 'ENROLL_STUDENT'
  AND type = 'PROCEDURE'
ORDER BY line;