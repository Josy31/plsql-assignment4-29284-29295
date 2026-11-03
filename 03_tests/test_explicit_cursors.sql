SET SERVEROUTPUT ON;

-- EXERCISE 1: Explicit cursor using OPEN, FETCH and CLOSE

DECLARE
    CURSOR student_cursor IS
        SELECT student_number, first_name, last_name, email
        FROM students
        ORDER BY student_number;

    v_student student_cursor%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('STUDENT LIST - OPEN/FETCH/CLOSE');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');

    OPEN student_cursor;

    LOOP
        FETCH student_cursor INTO v_student;
        EXIT WHEN student_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_student.student_number || ' | ' ||
            v_student.first_name || ' ' ||
            v_student.last_name || ' | ' ||
            v_student.email
        );
    END LOOP;

    CLOSE student_cursor;
END;
/

-- EXERCISE 2: Cursor FOR loop

DECLARE
    CURSOR student_cursor IS
        SELECT student_number, first_name, last_name, email
        FROM students
        ORDER BY student_number;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'STUDENT LIST - CURSOR FOR LOOP');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');

    FOR v_student IN student_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_student.student_number || ' | ' ||
            v_student.first_name || ' ' ||
            v_student.last_name || ' | ' ||
            v_student.email
        );
    END LOOP;
END;
/

-- EXERCISE 3: Explicit cursor joining four tables

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
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'STUDENT REGISTRATION AND GRADING REPORT');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');

    FOR v_record IN registration_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_record.student_number || ' | ' ||
            v_record.first_name || ' ' || v_record.last_name ||
            ' | ' || v_record.course_code ||
            ' | Marks: ' || NVL(TO_CHAR(v_record.marks), 'PENDING') ||
            ' | Grade: ' || NVL(v_record.letter_grade, 'PENDING') ||
            ' | Result: ' || NVL(v_record.result, 'PENDING')
        );
    END LOOP;
END;
/