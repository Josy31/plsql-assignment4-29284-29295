SET SERVEROUTPUT ON;

DECLARE
    v_registration_id registrations.registration_id%TYPE;
    v_test_grade_id grades.grade_id%TYPE;

BEGIN
    -- Create a savepoint so we can undo the test
    SAVEPOINT before_cursor_test;

    -- Find a registration that currently has no grade
    SELECT r.registration_id
    INTO v_registration_id
    FROM registrations r
    JOIN students s ON r.student_id = s.student_id
    JOIN courses c ON r.course_id = c.course_id
    WHERE s.student_number = 'STU008'
    AND c.course_code = 'BIT105';

    DBMS_OUTPUT.PUT_LINE('IMPLICIT CURSOR TEST');
    DBMS_OUTPUT.PUT_LINE('--------------------');

    -- 1. INSERT
    INSERT INTO grades (registration_id, marks)
    VALUES (v_registration_id, 60)
    RETURNING grade_id INTO v_test_grade_id;

    DBMS_OUTPUT.PUT_LINE('INSERT operation:');
    DBMS_OUTPUT.PUT_LINE('Rows inserted: ' || SQL%ROWCOUNT);

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: TRUE');
    END IF;

    -- 2. UPDATE
    UPDATE grades
    SET marks = 75
    WHERE grade_id = v_test_grade_id;

    DBMS_OUTPUT.PUT_LINE('UPDATE operation:');
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: TRUE');
    END IF;

    -- 3. DELETE
    DELETE FROM grades
    WHERE grade_id = v_test_grade_id;

    DBMS_OUTPUT.PUT_LINE('DELETE operation:');
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: TRUE');
    END IF;

    -- 4. UPDATE a nonexistent grade
    UPDATE grades
    SET marks = 80
    WHERE grade_id = -1;

    DBMS_OUTPUT.PUT_LINE('UPDATE nonexistent grade:');
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND: TRUE');
    END IF;

    -- Undo all test changes
    ROLLBACK TO before_cursor_test;

    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('Test changes rolled back.');

END;
/