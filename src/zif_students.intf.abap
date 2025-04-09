INTERFACE zif_students
  PUBLIC .

  METHODS create_student
        EXPORTING iv_student_name TYPE string
                  iv_student_age TYPE i
                  iv_major TYPE string
                  iv_email TYPE string
        RETURNING VALUE(rv_student_id) TYPE i.

    METHODS get_student
        EXPORTING iv_student_id TYPE i
        RETURNING VALUE(rs_student) TYPE REF TO zcl_ppv_student.

    "by requirement we do not have parameter iv_university_id
    "but from my understanding we must have the option to alter this field
    "in order to add/delete student from university
    METHODS update_student
        IMPORTING iv_student_id TYPE i
                  iv_name TYPE string
                  iv_age TYPE i
                  iv_major TYPE string
                  iv_email TYPE string
                  iv_university_id TYPE i.

ENDINTERFACE.
