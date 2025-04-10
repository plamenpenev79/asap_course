CLASS zcl_ppv_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA id TYPE i.
    DATA name TYPE string.
    DATA location TYPE string.

    DATA student TYPE REF TO zcl_ppv_student.

    INTERFACES zif_university.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_university IMPLEMENTATION.

    METHOD zif_university~create_university.

        "before inserting data we have to deal with auto-increment issue
        DATA l_incremented_id TYPE i.

        SELECT FROM zuniversity_ppv
            FIELDS id
            ORDER BY id DESCENDING
            INTO @DATA(l_latest_id)
            UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc = 0.
            l_incremented_id = l_latest_id + 1.
        ELSE.
            l_incremented_id = 1.
        ENDIF.

        DATA l_table_university TYPE TABLE OF zuniversity_ppv.

        DATA l_university_record LIKE LINE OF l_table_university.

        l_university_record-id = l_incremented_id.
        l_university_record-name = iv_university_name.
        l_university_record-location = iv_university_location.

        INSERT INTO zuniversity_ppv VALUES @l_university_record.

        IF sy-subrc = 0.
            "success
            SELECT SINGLE FROM zuniversity_ppv
                FIELDS id
                WHERE name = @iv_university_name AND
                      location = @iv_university_location
                INTO @DATA(res).

            rv_university_id = res.
        ELSE.
            rv_university_id = -1.
        ENDIF.

    ENDMETHOD.


    METHOD zif_university~add_student.

        student = NEW #(  ).

        DATA(l_student_id) = iv_student_id.

        DATA(l_student_found) = student->zif_students~get_student(
            IMPORTING iv_student_id = l_student_id
        ).

        l_student_found->university_id = id.

        student->zif_students~update_student(
            iv_student_id = l_student_found->student_id
            iv_name = l_student_found->name
            iv_age = l_student_found->age
            iv_major = l_student_found->major
            iv_email = l_student_found->email
            iv_university_id = l_student_found->university_id
        ).

    ENDMETHOD.


    METHOD zif_university~delete_student.

        student = NEW #(  ).

        DATA(l_student_id) = iv_student_id.

        DATA(l_student_found) = student->zif_students~get_student(
            IMPORTING iv_student_id = l_student_id
        ).

        l_student_found->university_id = -1.

        student->zif_students~update_student(
            iv_student_id = l_student_found->student_id
            iv_name = l_student_found->name
            iv_age = l_student_found->age
            iv_major = l_student_found->major
            iv_email = l_student_found->email
            iv_university_id = l_student_found->university_id
        ).

    ENDMETHOD.


    METHOD zif_university~list_students.

        SELECT FROM zstudent_ppv
            FIELDS *
            WHERE university_id = @id
            INTO @DATA(l_students_list).
        ENDSELECT.

        "assign list result to returning variable
        rs_students = l_students_list.

    ENDMETHOD.

ENDCLASS.
