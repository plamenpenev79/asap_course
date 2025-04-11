INTERFACE zif_university
  PUBLIC.

  TYPES t_student_instance TYPE REF TO zcl_ppv_student.
  TYPES t_db_students TYPE TABLE OF t_student_instance.

  METHODS create_university
        EXPORTING iv_university_name TYPE string
                  iv_university_location TYPE string
        RETURNING VALUE(rv_university_id) TYPE i.

    METHODS add_student
        IMPORTING iv_student_id TYPE i.

    METHODS delete_student
        IMPORTING iv_student_id TYPE i.

    METHODS list_students.

ENDINTERFACE.
