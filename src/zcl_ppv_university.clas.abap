CLASS zcl_ppv_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA id TYPE i.
    DATA name TYPE string.
    DATA location TYPE string.

    DATA student TYPE REF TO zcl_ppv_student.

    TYPES t_student TYPE zstudent_ppv.

    METHODS create_university
        EXPORTING iv_university_name TYPE string
                  iv_university_location TYPE string
        RETURNING VALUE(rv_university_id) TYPE i.

    METHODS add_student
        IMPORTING iv_student_id TYPE i.

    METHODS delete_student
        IMPORTING iv_student_id TYPE i.

    METHODS list_students
        RETURNING VALUE(rs_students) TYPE zstudent_ppv.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_university IMPLEMENTATION.

    METHOD create_university.

        DATA l_table_university TYPE TABLE OF zuniversity_ppv.

        DATA l_record LIKE LINE OF l_table_university.

        l_record-name = iv_university_name.
        l_record-location = iv_university_location.

        APPEND l_record TO l_table_university.

        INSERT zuniversity_ppv FROM TABLE @l_table_university.

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


    METHOD add_student.
        DATA(param) = iv_student_id.

        DATA(student_found) = student->get_student(
            IMPORTING iv_student_id = param
        ).

        student_found->university_id = id.

        student->update_student(
            iv_student_id = student_found->id
            iv_name = student_found->name
            iv_age = student_found->age
            iv_major = student_found->major
            iv_email = student_found->email
            iv_university_id = student_found->university_id
        ).

    ENDMETHOD.


    METHOD delete_student.

        DATA(param) = iv_student_id.

        DATA(student_found) = student->get_student(
            IMPORTING iv_student_id = param
        ).

        student_found->university_id = 0.

        student->update_student(
            iv_student_id = student_found->id
            iv_name = student_found->name
            iv_age = student_found->age
            iv_major = student_found->major
            iv_email = student_found->email
            iv_university_id = student_found->university_id
        ).

    ENDMETHOD.


    METHOD list_students.

        SELECT FROM zstudent_ppv
            FIELDS *
            WHERE university_id = @id
            INTO @DATA(students_list).
        ENDSELECT.

        "assign list result to returning variable
        rs_students = students_list.

    ENDMETHOD.

ENDCLASS.
