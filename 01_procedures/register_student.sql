CREATE OR REPLACE PROCEDURE register_student (
    p_student_number IN students.student_number%TYPE,
    p_first_name    IN students.first_name%TYPE,
    p_last_name     IN students.last_name%TYPE,
    p_email         IN students.email%TYPE
)
AS
BEGIN

    INSERT INTO students (
        student_number,
        first_name,
        last_name,
        email
    )
    VALUES (
        p_student_number,
        p_first_name,
        p_last_name,
        p_email
    );

    DBMS_OUTPUT.PUT_LINE(
        'Student registered successfully: ' ||
        p_student_number
    );

END;
/

SET SERVEROUTPUT ON;

BEGIN
    register_student(
        'STU011',
        'Olivia',
        'Mukamana',
        'olivia@gmail.com'
    );
END;
/

SELECT *
FROM students
WHERE student_number = 'STU011';

CREATE OR REPLACE PROCEDURE register_student (
    p_student_number IN students.student_number%TYPE,
    p_first_name    IN students.first_name%TYPE,
    p_last_name     IN students.last_name%TYPE,
    p_email         IN students.email%TYPE
)
AS
BEGIN

    INSERT INTO students (
        student_number,
        first_name,
        last_name,
        email
    )
    VALUES (
        p_student_number,
        p_first_name,
        p_last_name,
        p_email
    );

    DBMS_OUTPUT.PUT_LINE(
        'Student registered successfully: ' ||
        p_student_number
    );

EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

        DBMS_OUTPUT.PUT_LINE(
            'ERROR: Student number or email already exists.'
        );

    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'Unexpected error: ' || SQLERRM
        );

END;
/

SET SERVEROUTPUT ON;

BEGIN
    register_student(
        'STU011',
        'Olivia',
        'Mukamana',
        'olivia@gmail.com'
    );
END;
/

CREATE OR REPLACE PROCEDURE register_student (
    p_student_number IN students.student_number%TYPE,
    p_first_name    IN students.first_name%TYPE,
    p_last_name     IN students.last_name%TYPE,
    p_email         IN students.email%TYPE
)
AS
BEGIN

    -- Validate required input
    IF p_student_number IS NULL
       OR p_first_name IS NULL
       OR p_last_name IS NULL
       OR p_email IS NULL THEN

        RAISE_APPLICATION_ERROR(
            -20001,
            'All student information is required.'
        );

    END IF;

    -- Insert student
    INSERT INTO students (
        student_number,
        first_name,
        last_name,
        email
    )
    VALUES (
        p_student_number,
        p_first_name,
        p_last_name,
        p_email
    );

    DBMS_OUTPUT.PUT_LINE(
        'Student registered successfully: ' ||
        p_student_number
    );

EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

        RAISE_APPLICATION_ERROR(
            -20002,
            'Student number or email already exists.'
        );

    WHEN OTHERS THEN

        RAISE;

END;
/

SET SERVEROUTPUT ON;

BEGIN
    register_student(
        'STU012',
        'Michael',
        'Nkurunziza',
        'michael@gmail.com'
    );
END;
/

BEGIN
    register_student(
        'STU011',
        'Olivia',
        'Mukamana',
        'olivia@gmail.com'
    );
END;
/

BEGIN
    register_student(
        'STU013',
        NULL,
        'Nkurunziza',
        'michael2@gmail.com'
    );
END;
/