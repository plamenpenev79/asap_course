CLASS zcl_ppv_oop_task DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ppv_oop_task IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA student TYPE REF TO zcl_ppv_student.
    student = NEW #( ).

    DATA university TYPE REF TO zcl_ppv_university.
    university = NEW #(  ).

    "UNIVERSITY SECTION

    "test add university
    "---------------------------------------------------
    "university->name = 'Economics University'.
    "university->location = 'Varna'.

    "DATA(created_university_id) = university->zif_university~create_university(
    "    IMPORTING iv_university_name       = university->name
    "              iv_university_location   = university->location
    ").

    "IF created_university_id = -1.
    "    out->write( |University not created.| ).
    "ELSE.
    "    out->write( | University record with id -> { created_university_id } and name -> { university->name } and location -> { university->location } created . | ).
    "ENDIF.

    "test add student to university
    "---------------------------------------------------
    "DATA student_id TYPE i VALUE 29.
    "university->id = 5.

    "university->zif_university~add_student(
    "    iv_student_id = student_id
    ").

    "test delete student from university
    "---------------------------------------------------
    "DATA student_id TYPE i VALUE 29.

    "university->zif_university~delete_student(
    "    iv_student_id = student_id
    ").

    "test list students
    "---------------------------------------------------
    "university->id = 4.
    "university->zif_university~list_students( ).

    "END UNIVERSITY SECTION

    "test create student
    "---------------------------------------------------
    "student->age = 32.
    "student->name = 'Pavel Goranov'.
    "student->major = 'Ecoms'.
    "student->email = 'pgoranov@gmail.com'.

    "DATA(created_student_id) = student->zif_students~create_student(
    "    IMPORTING iv_student_name   = student->name
    "              iv_student_age    = student->age
    "              iv_major          = student->major
    "              iv_email          = student->email
    ").

    "IF created_student_id = -1.
    "    out->write( |Student not created.| ).
    "ELSE.
    "    out->write( |Student with id/name/age/major/email -> { created_student_id }/{ student->name }/{ student->age }/{ student->major }/{ student->email } created.| ).
    "ENDIF.

    "test get student by id
    "---------------------------------------------------
    "student->student_id = 23.

    "DATA(student_res) = student->zif_students~get_student(
    "    IMPORTING iv_student_id = student->student_id
    ").

    "out->write( |Student with id -> { student_res->student_id } found with name/age/major/email -> { student_res->name }/{ student_res->age }/{ student_res->major }/{ student_res->email }| ).

    "test update student
    "---------------------------------------------------
    "student->student_id = 29.
    "student->age = 30.
    "student->name = 'Plamen Gorov'.
    "student->major = 'Comms'.
    "student->email = 'pgorov@gmail.com'.

    "student->zif_students~update_student(
    "    iv_student_id      = student->student_id
    "    iv_name            = student->name
    "    iv_age             = student->age
    "    iv_major           = student->major
    "    iv_email           = student->email
    "    iv_university_id   = student->university_id
    ").

  ENDMETHOD.

ENDCLASS.
