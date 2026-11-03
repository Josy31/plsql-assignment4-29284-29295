CREATE OR REPLACE FUNCTION get_letter_grade (
    p_marks IN NUMBER
)
RETURN VARCHAR2
AS
BEGIN
    IF p_marks IS NULL OR p_marks < 0 OR p_marks > 100 THEN
        RAISE_APPLICATION_ERROR(
            -20009,
            'Marks must be between 0 and 100.'
        );
    ELSIF p_marks >= 80 THEN
        RETURN 'A';
    ELSIF p_marks >= 70 THEN
        RETURN 'B';
    ELSIF p_marks >= 60 THEN
        RETURN 'C';
    ELSIF p_marks >= 50 THEN
        RETURN 'D';
    ELSE
        RETURN 'F';
    END IF;
END;
/
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('85 marks: ' || get_letter_grade(85));
    DBMS_OUTPUT.PUT_LINE('75 marks: ' || get_letter_grade(75));
    DBMS_OUTPUT.PUT_LINE('65 marks: ' || get_letter_grade(65));
    DBMS_OUTPUT.PUT_LINE('55 marks: ' || get_letter_grade(55));
    DBMS_OUTPUT.PUT_LINE('35 marks: ' || get_letter_grade(35));
END;
/