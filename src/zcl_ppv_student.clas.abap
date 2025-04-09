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

    INTERFACES zif_students.

    DATA l_table_student TYPE TABLE OF zstudent_ppv.

    "working area
    DATA l_student_record LIKE LINE OF l_table_student.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_student IMPLEMENTATION.

    METHOD zif_students~create_student.

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


    METHOD zif_students~get_student.

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


    METHOD zif_students~update_student.

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
