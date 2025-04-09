INTERFACE zif_university
  PUBLIC .

  METHODS create_university
        EXPORTING iv_university_name TYPE string
                  iv_university_location TYPE string
        RETURNING VALUE(rv_university_id) TYPE i.

    METHODS add_student
        IMPORTING iv_student_id TYPE i.

    METHODS delete_student
        IMPORTING iv_student_id TYPE i.

    "by requirement we do not have returning value for this method but we must return a result from it -> list of students
    "so I added returning value
    METHODS list_students
        RETURNING VALUE(rs_students) TYPE zstudent_ppv.

ENDINTERFACE.
