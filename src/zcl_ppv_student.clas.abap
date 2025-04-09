CLASS zcl_ppv_student DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA id TYPE i.
    DATA university_id TYPE i.
    DATA name TYPE string.
    DATA age TYPE i.
    DATA major TYPE string.
    DATA email TYPE string.

    DATA l_table_student TYPE TABLE OF zstudent_ppv.

    "working area
    DATA l_student_record LIKE LINE OF l_table_student.

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

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_student IMPLEMENTATION.

    METHOD create_student.

        l_student_record-name = iv_student_name.
        l_student_record-age = iv_student_age.
        l_student_record-major = iv_major.
        l_student_record-email = iv_email.

        INSERT zstudent_ppv FROM @l_student_record.

        IF sy-subrc = 0.
            "success
            SELECT SINGLE FROM zstudent_ppv
                FIELDS id
                WHERE name = @iv_student_name AND
                      age = @iv_student_age AND
                      major = @iv_major AND
                      email = @iv_email
                INTO @DATA(res).

            rv_student_id = res.

        ENDIF.

    ENDMETHOD.


    METHOD get_student.

        SELECT SINGLE FROM zstudent_ppv
            FIELDS *
            WHERE id = @iv_student_id
            INTO @l_student_record.

        DATA l_student_res TYPE REF TO zcl_ppv_student.
        l_student_res = NEW #( ).

        l_student_res->id = l_student_record-id.
        l_student_res->name = l_student_record-name.
        l_student_res->age = l_student_record-age.
        l_student_res->major = l_student_record-major.
        l_student_res->email = l_student_record-email.
        l_student_res->university_id = l_student_record-university_id.

        rs_student = l_student_res.

    ENDMETHOD.


    METHOD update_student.

        UPDATE zstudent_ppv FROM @( VALUE #( id = iv_student_id
                                             name = iv_name
                                             age = iv_age
                                             major = iv_major
                                             email = iv_email
                                             university_id = iv_university_id ) ).

        IF sy-subrc = 0.
            "success
        ENDIF.

    ENDMETHOD.

ENDCLASS.
