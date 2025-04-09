CLASS zcl_ppv_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA id TYPE i.
    DATA name TYPE string.
    DATA location TYPE string.

    DATA student TYPE REF TO zcl_ppv_student.
    DATA if_student TYPE REF TO zif_students.

    TYPES t_student TYPE zstudent_ppv.

    INTERFACES zif_university.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_university IMPLEMENTATION.

    METHOD zif_university~create_university.

        DATA l_table_university TYPE TABLE OF zuniversity_ppv.

        DATA l_record LIKE LINE OF l_table_university.

        l_record-name = iv_university_name.
        l_record-location = iv_university_location.

        INSERT zuniversity_ppv FROM @l_record.

        IF sy-subrc = 0.
            "success
            SELECT SINGLE FROM zuniversity_ppv
                FIELDS id
                WHERE name = @iv_university_name AND
                      location = @iv_university_location
                INTO @DATA(res).

            rv_university_id = res.
        ENDIF.

    ENDMETHOD.


    METHOD zif_university~add_student.
        DATA(param) = iv_student_id.

        DATA(student_found) = if_student->get_student(
            IMPORTING iv_student_id = param
        ).

        student_found->university_id = id.

        if_student->update_student(
            iv_student_id = student_found->id
            iv_name = student_found->name
            iv_age = student_found->age
            iv_major = student_found->major
            iv_email = student_found->email
            iv_university_id = student_found->university_id
        ).

    ENDMETHOD.


    METHOD zif_university~delete_student.

        DATA(param) = iv_student_id.

        DATA(student_found) = if_student->get_student(
            IMPORTING iv_student_id = param
        ).

        student_found->university_id = 0.

        if_student->update_student(
            iv_student_id = student_found->id
            iv_name = student_found->name
            iv_age = student_found->age
            iv_major = student_found->major
            iv_email = student_found->email
            iv_university_id = student_found->university_id
        ).

    ENDMETHOD.


    METHOD zif_university~list_students.

        SELECT FROM zstudent_ppv
            FIELDS *
            WHERE university_id = @id
            INTO @DATA(students_list).
        ENDSELECT.

        "assign list result to returning variable
        rs_students = students_list.

    ENDMETHOD.

ENDCLASS.
