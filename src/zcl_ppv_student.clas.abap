CLASS zcl_ppv_student DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA student_id TYPE i.
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

        "before inserting data we have to deal with auto-increment issue
        DATA l_incremented_id TYPE i.

        SELECT FROM zstudent_ppv
        FIELDS student_id
            ORDER BY student_id DESCENDING
            INTO @DATA(latest_id)
            UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc = 0.
            l_incremented_id = latest_id + 1.
        ELSE.
            l_incremented_id = 1.
        ENDIF.

        l_student_record-student_id = l_incremented_id.
        l_student_record-university_id = -1.
        l_student_record-name = iv_student_name.
        l_student_record-age = iv_student_age.
        l_student_record-major = iv_major.
        l_student_record-email = iv_email.

        INSERT INTO zstudent_ppv VALUES @l_student_record.

        COMMIT WORK AND WAIT.

        "nested ifs again. Sorry
        IF sy-subrc = 0.
            SELECT SINGLE FROM zstudent_ppv
                FIELDS student_id
                WHERE student_id = @l_incremented_id
                INTO @DATA(l_student_id_found).

            IF sy-subrc = 0.
                rv_student_id = l_student_id_found.
            ELSE.
                rv_student_id = -1.
            ENDIF.
        ELSE.
            rv_student_id = -1.
        ENDIF.

    ENDMETHOD.


    METHOD zif_students~get_student.

        SELECT SINGLE FROM zstudent_ppv
            FIELDS *
            WHERE student_id = @iv_student_id
            INTO @l_student_record.

        DATA l_student_res TYPE REF TO zcl_ppv_student.
        l_student_res = NEW #( ).

        IF sy-subrc = 0.
            l_student_res->student_id       = l_student_record-student_id.
            l_student_res->name             = l_student_record-name.
            l_student_res->age              = l_student_record-age.
            l_student_res->major            = l_student_record-major.
            l_student_res->email            = l_student_record-email.
            l_student_res->university_id    = l_student_record-university_id.
        ENDIF.

        rs_student = l_student_res.

    ENDMETHOD.


    METHOD zif_students~update_student.

        UPDATE zstudent_ppv
            FROM @( VALUE #( student_id     = iv_student_id
                             name           = iv_name
                             age            = iv_age
                             major          = iv_major
                             email          = iv_email
                             university_id  = iv_university_id ) ).

        COMMIT WORK AND WAIT.

        IF sy-subrc = 0.
            "by design we return nothing from this method so just relax
        ENDIF.

    ENDMETHOD.

ENDCLASS.
