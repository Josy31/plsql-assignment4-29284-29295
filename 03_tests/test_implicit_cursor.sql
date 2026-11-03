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
SET SERVEROUTPUT ON;

DECLARE

    -- 1. DECLARE the explicit cursor
    CURSOR student_cursor IS
        SELECT student_number, first_name, last_name, email
        FROM students
        ORDER BY student_number;

    -- Variable to hold one fetched row
    v_student student_cursor%ROWTYPE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('STUDENT REGISTRATION LIST');
    DBMS_OUTPUT.PUT_LINE('-------------------------');

    -- 2. OPEN the cursor
    OPEN student_cursor;

    LOOP

        -- 3. FETCH one row
        FETCH student_cursor INTO v_student;

        -- Stop when no more rows are available
        EXIT WHEN student_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_student.student_number || ' | ' ||
            v_student.first_name || ' ' ||
            v_student.last_name || ' | ' ||
            v_student.email
        );

    END LOOP;

    -- 4. CLOSE the cursor
    CLOSE student_cursor;

END;
/

SET SERVEROUTPUT ON;

DECLARE

    CURSOR student_cursor IS
        SELECT student_number, first_name, last_name, email
        FROM students
        ORDER BY student_number;

BEGIN

    DBMS_OUTPUT.PUT_LINE('STUDENT LIST USING CURSOR FOR LOOP');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');

    FOR v_student IN student_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_student.student_number || ' | ' ||
            v_student.first_name || ' ' ||
            v_student.last_name || ' | ' ||
            v_student.email
        );
    END LOOP;

END;
/

SET SERVEROUTPUT ON;

DECLARE

    CURSOR registration_cursor IS
        SELECT
            s.student_number,
            s.first_name,
            s.last_name,
            c.course_code,
            c.course_name,
            g.marks,
            g.letter_grade,
            g.result
        FROM registrations r
        JOIN students s
            ON r.student_id = s.student_id
        JOIN courses c
            ON r.course_id = c.course_id
        LEFT JOIN grades g
            ON r.registration_id = g.registration_id
        ORDER BY s.student_number, c.course_code;

BEGIN

    DBMS_OUTPUT.PUT_LINE('STUDENT REGISTRATION AND GRADES REPORT');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');

    FOR rec IN registration_cursor
    LOOP

        DBMS_OUTPUT.PUT_LINE(
            rec.student_number || ' | ' ||
            rec.first_name || ' ' || rec.last_name ||
            ' | ' || rec.course_code ||
            ' | Marks: ' || NVL(TO_CHAR(rec.marks), 'NOT GRADED') ||
            ' | Grade: ' || NVL(rec.letter_grade, 'PENDING') ||
            ' | Result: ' || NVL(rec.result, 'PENDING')
        );

    END LOOP;

END;
/