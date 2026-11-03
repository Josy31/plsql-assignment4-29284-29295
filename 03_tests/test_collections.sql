SET SERVEROUTPUT ON;

DECLARE

    -- Define an associative array
    TYPE student_names_type IS TABLE OF VARCHAR2(100)
    INDEX BY PLS_INTEGER;

    -- Declare the collection
    v_student_names student_names_type;

BEGIN

    -- Store student names using their student IDs as indexes
    FOR student_rec IN (
        SELECT student_id, first_name || ' ' || last_name AS full_name
        FROM students
        ORDER BY student_id
    )
    LOOP
        v_student_names(student_rec.student_id) := student_rec.full_name;
    END LOOP;

    -- Display stored student names
    DBMS_OUTPUT.PUT_LINE('STUDENT NAMES COLLECTION');
    DBMS_OUTPUT.PUT_LINE('-------------------------');

    FOR i IN v_student_names.FIRST .. v_student_names.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Student ID: ' || i ||
            ' | Name: ' || v_student_names(i)
        );
    END LOOP;

END;
/

SET SERVEROUTPUT ON;

DECLARE

    -- Define a nested table
    TYPE course_names_type IS TABLE OF VARCHAR2(100);

    -- Declare and initialize the collection
    v_course_names course_names_type := course_names_type();

BEGIN

    -- Retrieve course names and add them to the collection
    FOR course_rec IN (
        SELECT course_name
        FROM courses
        ORDER BY course_code
    )
    LOOP
        v_course_names.EXTEND;

        v_course_names(v_course_names.LAST) :=
            course_rec.course_name;
    END LOOP;

    -- Display the collection
    DBMS_OUTPUT.PUT_LINE('COURSE NAMES NESTED TABLE');
    DBMS_OUTPUT.PUT_LINE('-------------------------');

    FOR i IN 1 .. v_course_names.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Course ' || i || ': ' || v_course_names(i)
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(
        'Total courses: ' || v_course_names.COUNT
    );

END;
/

SET SERVEROUTPUT ON;

DECLARE

    -- Define a VARRAY with a maximum capacity of 5 marks
    TYPE student_marks_type IS VARRAY(5) OF NUMBER(5,2);

    -- Initialize the VARRAY
    v_marks student_marks_type := student_marks_type();

    v_total NUMBER := 0;
    v_average NUMBER(5,2);

BEGIN

    -- Add five marks
    v_marks.EXTEND(5);

    v_marks(1) := 85;
    v_marks(2) := 72;
    v_marks(3) := 90;
    v_marks(4) := 65;
    v_marks(5) := 78;

    -- Display marks and calculate total
    DBMS_OUTPUT.PUT_LINE('STUDENT MARKS VARRAY');
    DBMS_OUTPUT.PUT_LINE('-------------------');

    FOR i IN 1 .. v_marks.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Student ' || i || ': ' || v_marks(i)
        );

        v_total := v_total + v_marks(i);
    END LOOP;

    -- Calculate average
    v_average := v_total / v_marks.COUNT;

    DBMS_OUTPUT.PUT_LINE('-------------------');
    DBMS_OUTPUT.PUT_LINE('Total Marks: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Average Mark: ' || v_average);

END;
/