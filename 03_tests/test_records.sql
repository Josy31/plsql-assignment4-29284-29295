    SET SERVEROUTPUT ON;

DECLARE
    -- Create a record based on the STUDENTS table
    v_student students%ROWTYPE;

BEGIN
    -- Retrieve one student's complete record
    SELECT *
    INTO v_student
    FROM students
    WHERE student_number = 'STU001';

    -- Display the record fields
    DBMS_OUTPUT.PUT_LINE('STUDENT INFORMATION');
    DBMS_OUTPUT.PUT_LINE('-------------------');

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_student.student_id);
    DBMS_OUTPUT.PUT_LINE('Student Number: ' || v_student.student_number);
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_student.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_student.last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_student.email);
    DBMS_OUTPUT.PUT_LINE('Registration Date: ' ||
                         TO_CHAR(v_student.registration_date, 'DD-MON-YYYY'));

END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_student students%ROWTYPE;

BEGIN
    SELECT *
    INTO v_student
    FROM students
    WHERE student_number = 'STU001';

    DBMS_OUTPUT.PUT_LINE('STUDENT INFORMATION');
    DBMS_OUTPUT.PUT_LINE('-------------------');

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_student.student_id);
    DBMS_OUTPUT.PUT_LINE('Student Number: ' || v_student.student_number);
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_student.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_student.last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_student.email);

    DBMS_OUTPUT.PUT_LINE(
        'Registration Date: ' ||
        TO_CHAR(v_student.registration_date, 'DD-MON-YYYY')
    );

END;
/

SET SERVEROUTPUT ON;

DECLARE

    -- Define our own record structure
    TYPE student_info_type IS RECORD (
        student_number students.student_number%TYPE,
        full_name      VARCHAR2(100),
        email_address  students.email%TYPE
    );

    -- Declare a variable using our custom record
    v_student student_info_type;

BEGIN

    SELECT
        student_number,
        first_name || ' ' || last_name,
        email
    INTO
        v_student.student_number,
        v_student.full_name,
        v_student.email_address
    FROM students
    WHERE student_number = 'STU001';

    DBMS_OUTPUT.PUT_LINE('CUSTOM STUDENT RECORD');
    DBMS_OUTPUT.PUT_LINE('---------------------');

    DBMS_OUTPUT.PUT_LINE('Student Number: ' || v_student.student_number);
    DBMS_OUTPUT.PUT_LINE('Full Name: ' || v_student.full_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_student.email_address);

END;
/