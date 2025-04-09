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

    "test add university
    university->name = 'Free University'.
    university->location = 'Plovdiv'.

    "DATA(res) = university->create_university(
    "    IMPORTING iv_university_name = university->name
    "              iv_university_location = university->location
    ").

    "out->write( | University record with id -> { res } and name -> { university->name } and location -> { university->location } created . | ).

    "test create student
    student->id = 1.
    student->age = 31.
    student->name = 'Kikkork'.
    student->major = 'Lor'.
    student->email = 'kikkork@gmail.com'.

    DATA(created_student_id) = student->create_student(
        IMPORTING iv_student_name = student->name
                  iv_student_age = student->age
                  iv_major = student->major
                  iv_email = student->email
    ).

    out->write( |Student with id/name/age/major/email -> { created_student_id }/{ student->name }/{ student->age }/{ student->major }/{ student->email } created.| ).

    "test get student by id
    student->id = 23.

    DATA(student_res) = student->get_student(
        IMPORTING iv_student_id = student->id
    ).

    out->write( |Student fetched with id/name/age/major/email -> { student_res->id }/{ student_res->name }/{ student_res->age }/{ student_res->major }/{ student_res->email }| ).

    "test update student
    student->id = 23.
    student->age = 19.
    student->name = 'Plamen'.
    student->major = 'Dimcho'.
    student->email = 'rub@mailer.com'.

    student->update_student(
        iv_student_id = student->id
        iv_name = student->name
        iv_age = student->age
        iv_major = student->major
        iv_email = student->email
        iv_university_id = student->university_id
    ).

    "test list students
    DATA(students_list) = university->list_students( ).

    out->write( '--------List students----------' ).
    out->write( students_list ).

  ENDMETHOD.

ENDCLASS.
