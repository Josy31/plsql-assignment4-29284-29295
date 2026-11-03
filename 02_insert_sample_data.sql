
INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU001', 'Aline', 'Uwase', 'aline@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU002', 'Jean', 'Niyonzima', 'jean@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU003', 'Eric', 'Mugisha', 'eric@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU004', 'Diane', 'Mukamana', 'diane@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU005', 'Patrick', 'Habimana', 'patrick@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU006', 'Grace', 'Iradukunda', 'grace@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU007', 'David', 'Nsengimana', 'david@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU008', 'Sarah', 'Umutoni', 'sarah@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU009', 'Kevin', 'Bizimana', 'kevin@gmail.com');

INSERT INTO students (student_number, first_name, last_name, email)
VALUES ('STU010', 'Esther', 'Nyirahabimana', 'esther@gmail.com');

COMMIT;

SELECT COUNT(*) AS total_students FROM students;

INSERT INTO courses (course_code, course_name, credits)
VALUES ('BIT101', 'Introduction to IT', 3);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('BIT102', 'Database Management Systems', 4);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('BIT103', 'Programming Fundamentals', 4);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('BIT104', 'Computer Networks', 3);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('BIT105', 'Business Management', 3);

COMMIT;

SELECT COUNT(*) AS total_courses FROM courses;
SELECT course_id, course_code, course_name, credits
FROM courses
ORDER BY course_id;

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU001'
AND c.course_code IN ('BIT101', 'BIT102');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU002'
AND c.course_code IN ('BIT101', 'BIT103');


INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU003'
AND c.course_code IN ('BIT102', 'BIT104');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU004'
AND c.course_code IN ('BIT103', 'BIT105');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU005'
AND c.course_code IN ('BIT101', 'BIT104');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU006'
AND c.course_code IN ('BIT102', 'BIT105');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU007'
AND c.course_code IN ('BIT103', 'BIT104');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU008'
AND c.course_code IN ('BIT101', 'BIT105');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU009'
AND c.course_code IN ('BIT102', 'BIT103');

INSERT INTO registrations (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s CROSS JOIN courses c
WHERE s.student_number = 'STU010'
AND c.course_code IN ('BIT104', 'BIT105');

COMMIT;

SELECT COUNT(*) AS total_registrations
FROM registrations;
SELECT
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    r.status
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
ORDER BY s.student_number, c.course_code;
-- STUDENT GRADES SAMPLE DATA

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 85
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU001'
AND c.course_code = 'BIT101';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 72
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU001'
AND c.course_code = 'BIT102';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 65
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU002'
AND c.course_code = 'BIT101';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 90
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU002'
AND c.course_code = 'BIT103';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 55
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU003'
AND c.course_code = 'BIT102';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 78
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU003'
AND c.course_code = 'BIT104';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 95
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU004'
AND c.course_code = 'BIT103';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 48
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU004'
AND c.course_code = 'BIT105';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 81
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU005'
AND c.course_code = 'BIT101';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 68
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU005'
AND c.course_code = 'BIT104';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 88
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU006'
AND c.course_code = 'BIT102';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 74
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU006'
AND c.course_code = 'BIT105';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 59
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU007'
AND c.course_code = 'BIT103';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 93
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU007'
AND c.course_code = 'BIT104';

INSERT INTO grades (registration_id, marks)
SELECT r.registration_id, 70
FROM registrations r
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
WHERE s.student_number = 'STU008'
AND c.course_code = 'BIT101';

COMMIT;

SELECT COUNT(*) AS total_grades FROM grades;
SELECT
    s.student_number,
    s.first_name,
    c.course_code,
    g.marks,
    g.letter_grade,
    g.result
FROM grades g
JOIN registrations r ON g.registration_id = r.registration_id
JOIN students s ON r.student_id = s.student_id
JOIN courses c ON r.course_id = c.course_id
ORDER BY s.student_number, c.course_code;