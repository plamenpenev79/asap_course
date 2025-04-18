CLASS zcl_ppv_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA id TYPE i.
    DATA name TYPE string.
    DATA location TYPE string.

    DATA l_student_instance TYPE REF TO zcl_ppv_student.

    INTERFACES zif_university.

    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "local internal table to hold students
    "it is not said that this list should be accessible from outside
    "so we assume that it is private and will be accessed via methods
    TYPES t_it_student TYPE REF TO zcl_ppv_student.
    TYPES t_it_students TYPE TABLE OF t_it_student.
    DATA it_students TYPE t_it_students.
ENDCLASS.



CLASS zcl_ppv_university IMPLEMENTATION.

    METHOD constructor.

        "we fetch students from ID for this university and store in internal table of students
        me->zif_university~list_students( ).

    ENDMETHOD.

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

        COMMIT WORK AND WAIT.

        IF sy-subrc <> 0.
            rv_university_id = -1.
            EXIT.
        ENDIF.

        SELECT SINGLE FROM zuniversity_ppv
            FIELDS id
            WHERE name      = @iv_university_name AND
                  location  = @iv_university_location
            INTO @DATA(res).

        IF sy-subrc <> 0.
            rv_university_id = -1.
            EXIT.
        ENDIF.

        rv_university_id = res.

    ENDMETHOD.


    METHOD zif_university~add_student.

        l_student_instance = NEW #(  ).

        DATA(l_student_id) = iv_student_id.

        DATA(l_student_found) = l_student_instance->zif_students~get_student(
            IMPORTING iv_student_id = l_student_id
        ).

        IF sy-subrc = 0.
            "there is a student with this id
            "so we can update his university id to assign him to our university
            l_student_found->university_id = id.

            l_student_instance->zif_students~update_student(
                iv_student_id       = l_student_found->student_id
                iv_name             = l_student_found->name
                iv_age              = l_student_found->age
                iv_major            = l_student_found->major
                iv_email            = l_student_found->email
                iv_university_id    = l_student_found->university_id
            ).

            IF sy-subrc = 0.
                "we should update the local list of students if we have successfully updated the university id
                APPEND l_student_found TO it_students.
            ENDIF.
        ENDIF.

    ENDMETHOD.


    METHOD zif_university~delete_student.

        l_student_instance = NEW #(  ).

        DATA(l_student_id) = iv_student_id.

        DATA(l_student_found) = l_student_instance->zif_students~get_student(
            IMPORTING iv_student_id = l_student_id
        ).

        IF sy-subrc = 0.
            "from the requirement it is not clear if we want to delete the whole student record
            "or just to sign him off by updating university_id
            "since we do not have delete_student as a method for student class -> we assume that student's record should stay

            "student with this id exists
            "so we can sign him off our university by resetting his university id
            l_student_found->university_id = -1.

            l_student_instance->zif_students~update_student(
                iv_student_id       = l_student_found->student_id
                iv_name             = l_student_found->name
                iv_age              = l_student_found->age
                iv_major            = l_student_found->major
                iv_email            = l_student_found->email
                iv_university_id    = l_student_found->university_id
            ).

            IF sy-subrc = 0.
                "do nothing
            ENDIF.
        ENDIF.

    ENDMETHOD.


    METHOD zif_university~list_students.

        SELECT FROM zstudent_ppv
            FIELDS *
            WHERE university_id = @me->id
            INTO TABLE @DATA(l_students_list).

        IF sy-subrc = 0.
            LOOP AT l_students_list INTO DATA(rec).
                DATA student TYPE t_it_student.
                student = NEW #(  ).

                student->student_id     = rec-student_id.
                student->name           = rec-name.
                student->age            = rec-age.
                student->major          = rec-major.
                student->email          = rec-email.
                student->university_id  = rec-university_id.

                APPEND student to it_students.
            ENDLOOP.
        ENDIF.

    ENDMETHOD.

ENDCLASS.
