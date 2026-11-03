SET SERVEROUTPUT ON;

DECLARE

    -- Collection for grade IDs
    TYPE grade_id_type IS TABLE OF grades.grade_id%TYPE
    INDEX BY PLS_INTEGER;

    -- Collection for marks
    TYPE marks_type IS TABLE OF grades.marks%TYPE
    INDEX BY PLS_INTEGER;

    v_grade_ids grade_id_type;
    v_marks marks_type;

BEGIN

    -- Step 1: Retrieve multiple records
    SELECT grade_id, marks
    BULK COLLECT INTO v_grade_ids, v_marks
    FROM grades
    ORDER BY grade_id;

    DBMS_OUTPUT.PUT_LINE('BULK PROCESSING REPORT');
    DBMS_OUTPUT.PUT_LINE('----------------------');

    DBMS_OUTPUT.PUT_LINE(
        'Records retrieved: ' || v_grade_ids.COUNT
    );

    -- Step 2: Update multiple records in bulk
    FORALL i IN 1 .. v_grade_ids.COUNT

        UPDATE grades
        SET
            letter_grade =
                CASE
                    WHEN v_marks(i) >= 80 THEN 'A'
                    WHEN v_marks(i) >= 70 THEN 'B'
                    WHEN v_marks(i) >= 60 THEN 'C'
                    WHEN v_marks(i) >= 50 THEN 'D'
                    ELSE 'F'
                END,

            result =
                CASE
                    WHEN v_marks(i) >= 50 THEN 'PASS'
                    ELSE 'FAIL'
                END

        WHERE grade_id = v_grade_ids(i);

    -- Step 3: Display affected rows
    DBMS_OUTPUT.PUT_LINE(
        'Records updated: ' || SQL%ROWCOUNT
    );

    DBMS_OUTPUT.PUT_LINE(
        'Bulk processing completed successfully.'
    );

END;
/
SELECT
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
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
ORDER BY s.student_number, c.course_code;

SET SERVEROUTPUT ON;

DECLARE

    TYPE registration_ids_type IS TABLE OF
        registrations.registration_id%TYPE
        INDEX BY PLS_INTEGER;

    TYPE marks_type IS TABLE OF
        grades.marks%TYPE
        INDEX BY PLS_INTEGER;

    v_registration_ids registration_ids_type;
    v_marks marks_type;

    v_id1 registrations.registration_id%TYPE;
    v_id2 registrations.registration_id%TYPE;
    v_id3 registrations.registration_id%TYPE;
    v_id4 registrations.registration_id%TYPE;

    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381);

BEGIN

    SAVEPOINT before_bulk_error_test;

    -- Retrieve the four registration IDs

    SELECT r.registration_id INTO v_id1
    FROM registrations r
    JOIN students s ON r.student_id = s.student_id
    JOIN courses c ON r.course_id = c.course_id
    WHERE s.student_number = 'STU008'
      AND c.course_code = 'BIT105';

    SELECT r.registration_id INTO v_id2
    FROM registrations r
    JOIN students s ON r.student_id = s.student_id
    JOIN courses c ON r.course_id = c.course_id
    WHERE s.student_number = 'STU001'
      AND c.course_code = 'BIT101';

    SELECT r.registration_id INTO v_id3
    FROM registrations r
    JOIN students s ON r.student_id = s.student_id
    JOIN courses c ON r.course_id = c.course_id
    WHERE s.student_number = 'STU009'
      AND c.course_code = 'BIT102';

    SELECT r.registration_id INTO v_id4
    FROM registrations r
    JOIN students s ON r.student_id = s.student_id
    JOIN courses c ON r.course_id = c.course_id
    WHERE s.student_number = 'STU010'
      AND c.course_code = 'BIT104';

    -- Populate collections

    v_registration_ids(1) := v_id1;
    v_registration_ids(2) := v_id2;
    v_registration_ids(3) := v_id3;
    v_registration_ids(4) := v_id4;

    v_marks(1) := 80;
    v_marks(2) := 75;
    v_marks(3) := 120;
    v_marks(4) := 65;

    DBMS_OUTPUT.PUT_LINE('BULK EXCEPTION HANDLING TEST');
    DBMS_OUTPUT.PUT_LINE('----------------------------');

    BEGIN

        -- Perform bulk insert and continue after individual errors

        FORALL i IN 1 .. v_registration_ids.COUNT SAVE EXCEPTIONS

            INSERT INTO grades (registration_id, marks)
            VALUES (v_registration_ids(i), v_marks(i));

        DBMS_OUTPUT.PUT_LINE('All insertions succeeded.');

    EXCEPTION

        WHEN e_bulk_errors THEN

            DBMS_OUTPUT.PUT_LINE(
                'Bulk operation completed with errors.'
            );

            DBMS_OUTPUT.PUT_LINE('----------------------------');
            DBMS_OUTPUT.PUT_LINE('INDIVIDUAL OPERATION RESULTS');

            FOR i IN 1 .. v_registration_ids.COUNT
            LOOP

                DBMS_OUTPUT.PUT_LINE(
                    'Operation ' || i ||
                    ' | Rows affected: ' || SQL%BULK_ROWCOUNT(i)
                );

            END LOOP;

            DBMS_OUTPUT.PUT_LINE('----------------------------');
            DBMS_OUTPUT.PUT_LINE('ERROR DETAILS');

            FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
            LOOP

                DBMS_OUTPUT.PUT_LINE(
                    'Failed operation: ' ||
                    SQL%BULK_EXCEPTIONS(i).ERROR_INDEX
                );

                DBMS_OUTPUT.PUT_LINE(
                    'Oracle error code: ' ||
                    SQL%BULK_EXCEPTIONS(i).ERROR_CODE
                );

                DBMS_OUTPUT.PUT_LINE(
                    'Error message: ' ||
                    SQLERRM(
                        -SQL%BULK_EXCEPTIONS(i).ERROR_CODE
                    )
                );

                DBMS_OUTPUT.PUT_LINE('----------------------------');

            END LOOP;

    END;

    -- Remove all test insertions
    ROLLBACK TO before_bulk_error_test;

    DBMS_OUTPUT.PUT_LINE(
        'Test insertions rolled back successfully.'
    );

END;
/