CLASS zcl_ppv_tasks DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES zif_abap_course_basics .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ppv_tasks IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA instance TYPE REF TO zcl_ppv_tasks.
    instance = NEW #( ).

    "Task 1 / hello world
    out->write( '---------------Hello world---------------' ).
    DATA res_string TYPE string.

    res_string = instance->zif_abap_course_basics~hello_world(
       iv_name = 'Plamen'
    ).

    out->write( res_string ).

    "Task 2 / calculator
    out->write( '---------------Calculator---------------' ).

    DATA res_calculator TYPE i.
    DATA iv_first_val TYPE i VALUE 94565.
    DATA iv_second_val TYPE i VALUE 102.
    DATA iv_operator_val TYPE c VALUE '*'.

    TRY.
        res_calculator = instance->zif_abap_course_basics~calculator(
        iv_first_number = iv_first_val
        iv_second_number = iv_second_val
        iv_operator = iv_operator_val
     ).
    CATCH cx_abap_invalid_value.
        out->write( 'Invalid operator' ).
    ENDTRY.

     out->write( | { iv_first_val } { iv_operator_val } { iv_second_val } = { res_calculator } | ).

     "Task 3 / FizzBuzz
     out->write( '---------------FizzBuzz---------------' ).
     out->write( instance->zif_abap_course_basics~fizz_buzz( ) ).

     "Task 4 / date parsing
     out->write( '---------------Date parsing---------------' ).
     DATA date_test TYPE string VALUE '3 September 2034'.
     DATA res_date TYPE d.

     res_date = instance->zif_abap_course_basics~date_parsing(
        iv_date = date_test
     ).

     out->write( | Parsed { date_test } to { res_date } | ).

     "Task 5 / scrabble score
     out->write( '---------------Scrabble score---------------' ).
     DATA res_scrabble_score TYPE i.

     res_scrabble_score = instance->zif_abap_course_basics~scrabble_score(
        iv_word = 'RoSs'
     ).

     out->write( | Scrabble score -> { res_scrabble_score } | ).

     "Task 6 / current date/time
     out->write( '---------------Get current date/time---------------' ).
     DATA res_timestamp TYPE timestampl.

     res_timestamp = instance->zif_abap_course_basics~get_current_date_time( ).

     out->write( res_timestamp ).

     "Task 7 / internal tables
     out->write( '---------------Internal tables---------------' ).

     DATA travel_records_7_1 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.
     DATA travel_records_7_2 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.
     DATA travel_records_7_3 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.

     instance->zif_abap_course_basics~internal_tables(
        IMPORTING et_travel_ids_task7_1 = travel_records_7_1
                et_travel_ids_task7_2 = travel_records_7_2
                et_travel_ids_task7_3 = travel_records_7_3
     ).

     out->write( '---------------7.1---------------' ).
     out->write( data = travel_records_7_1 ).
     out->write( '---------------7.2---------------' ).
     out->write( data = travel_records_7_2 ).
     out->write( '---------------7.3---------------' ).
     out->write( data = travel_records_7_3 ).

     "Task 8 / Open SQL
     out->write( '---------------Open SQL---------------' ).

     DATA travel_records_8_1 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.
     DATA travel_records_8_2 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.
     DATA travel_records_8_3 TYPE TABLE OF zif_abap_course_basics~lts_travel_id.

     instance->zif_abap_course_basics~open_sql(
        IMPORTING et_travel_ids_task8_1 = travel_records_8_1
                et_travel_ids_task8_2 = travel_records_8_2
                et_travel_ids_task8_3 = travel_records_8_3
     ).

     out->write( '---------------8.1---------------' ).
     out->write( data = travel_records_8_1 ).
     out->write( '---------------8.2---------------' ).
     out->write( data = travel_records_8_2 ).
     out->write( '---------------8.3---------------' ).
     out->write( data = travel_records_8_3 ).

  ENDMETHOD.


  METHOD zif_abap_course_basics~calculator.
    IF iv_operator <> '+' AND iv_operator <> '-' AND iv_operator <> '*' AND iv_operator <> '/'.
        RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    CASE iv_operator.
        WHEN '+'.
            rv_result = iv_first_number + iv_second_number.
        WHEN '-'.
            rv_result = iv_first_number - iv_second_number.
        WHEN '*'.
            rv_result = iv_first_number * iv_second_number.
        WHEN '/'.
            rv_result = iv_first_number / iv_second_number.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_abap_course_basics~date_parsing.
    DATA day TYPE string.
    DATA month TYPE string.
    DATA year TYPE string.

    "used only for conversion check purposes
    DATA i_month TYPE i.
    DATA i_day TYPE i.
    DATA i_year TYPE i.

    SPLIT iv_date AT ' ' INTO day month year.

    IF STRLEN( month ) > 2.
        "we assume we have month written in letters
        "this solution of mapping month strings to digits is lame af but it works
        CASE month.
            WHEN 'January'.
                month = '1'.
            WHEN 'February'.
                month = '2'.
            WHEN 'March'.
                month = '3'.
            WHEN 'April'.
                month = '4'.
            WHEN 'May'.
                month = '5'.
            WHEN 'June'.
                month = '6'.
            WHEN 'July'.
                month = '7'.
            WHEN 'August'.
                month = '8'.
            WHEN 'September'.
                month = '9'.
            WHEN 'October'.
                month = '10'.
            WHEN 'November'.
                month = '11'.
            WHEN 'December'.
                month = '12'.
        ENDCASE.
    ENDIF.

    "check if date fields can be parsed as numbers
    TRY.
        i_day = day.
        i_month = month.
        i_year = year.
    CATCH cx_sy_conversion_no_number.
        "date field is in unparseable format so propagate exception to caller or return error message...
    ENDTRY.

    IF i_month < 1 OR i_month > 12. EXIT. ENDIF.

    IF i_day < 1 OR i_day > 31. EXIT. ENDIF.

    "max year length should be 4 digits
    IF STRLEN( year ) > 4. EXIT. ENDIF.

    "because we want to follow the standard format DDDDMMYY
    "add leading 0 if day is 1..9
    IF i_day BETWEEN 1 AND 9.
        day = '0' && day.
    ENDIF.

    "add leading 0 if month is 1..9
    IF i_month BETWEEN 1 AND 9.
        month = '0' && month.
    ENDIF.

    CONCATENATE year month day INTO rv_result.
  ENDMETHOD.


  METHOD zif_abap_course_basics~fizz_buzz.
    DATA num TYPE i VALUE 1.
    DATA new_line TYPE string VALUE cl_abap_char_utilities=>cr_lf.

    DO.
        IF ( num MOD 3 = 0 ) AND ( num MOD 5 = 0 ).
            rv_result &&= | { num } -> FizzBuzz{ new_line } |.
        ELSEIF ( num MOD 3 = 0 ).
            rv_result &&= | { num } -> Fizz{ new_line } |.
        ELSEIF ( num MOD 5 = 0 ).
            rv_result &&= | { num } -> Buzz{ new_line } |.
        ELSE.
            rv_result &&= | { num }{ new_line } |.
        ENDIF.

        IF num = 100. EXIT. ENDIF.

        num = num + 1.
    ENDDO.
  ENDMETHOD.


  METHOD zif_abap_course_basics~get_current_date_time.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    rv_result = lv_timestamp.
  ENDMETHOD.


  METHOD zif_abap_course_basics~hello_world.
    rv_result = | Hello { iv_name }, your system user is { sy-uname }. | .
  ENDMETHOD.


  METHOD zif_abap_course_basics~internal_tables.
    DATA ppv_helper TYPE REF TO ppv_helper.
    ppv_helper = NEW #( ).

    ppv_helper->migrate_data_from_db( ).

    SELECT FROM ZTRAVEL_PPV FIELDS * INTO TABLE @DATA(l_travel_records).

    "7.1
    DATA l_travel_records_filtered TYPE TABLE OF ppv_helper->travel_record.

    SELECT *
        FROM @l_travel_records as a
         WHERE agency_id = '070001' AND
         booking_fee = 20 AND
         currency_code = 'JPY'
         INTO CORRESPONDING FIELDS OF TABLE @l_travel_records_filtered.

    DATA filtered_ids TYPE TABLE OF string.

    LOOP AT l_travel_records_filtered INTO DATA(rec).
        APPEND rec-travel_id TO filtered_ids.
    ENDLOOP.

    et_travel_ids_task7_1 = filtered_ids.

    "7.2
    CLEAR filtered_ids.
    CLEAR l_travel_records_filtered.

    SELECT *
        FROM @l_travel_records as a
         WHERE total_price > 2000 AND
         currency_code = 'USD'
         INTO CORRESPONDING FIELDS OF TABLE @l_travel_records_filtered.

    LOOP AT l_travel_records_filtered INTO rec.
        APPEND rec-travel_id TO filtered_ids.
    ENDLOOP.

    et_travel_ids_task7_2 = filtered_ids.

    "7.3
    CLEAR filtered_ids.
    CLEAR l_travel_records_filtered.

    DELETE l_travel_records WHERE currency_code <> 'EUR'.

    SORT l_travel_records BY total_price begin_date.

    SELECT * FROM @l_travel_records as a
        INTO CORRESPONDING FIELDS OF TABLE @l_travel_records_filtered
        UP TO 10 ROWS.

    LOOP AT l_travel_records_filtered INTO rec.
        APPEND rec-travel_id TO filtered_ids.
    ENDLOOP.

    et_travel_ids_task7_3 = filtered_ids.

  ENDMETHOD.


  METHOD zif_abap_course_basics~open_sql.

    "8.1
    SELECT travel_id FROM ZTRAVEL_PPV
        WHERE agency_id = '070001' AND
                booking_fee = 20 AND
                currency_code = 'JPY'
        INTO TABLE @DATA(res_8_1).

   et_travel_ids_task8_1 = res_8_1.

   "8.2
   SELECT travel_id FROM ZTRAVEL_PPV
        WHERE total_price > 2000 AND
                currency_code = 'USD'
        INTO TABLE @DATA(res_8_2).

   et_travel_ids_task8_2 = res_8_2.

   "8.3
   SELECT travel_id FROM ZTRAVEL_PPV
        WHERE currency_code = 'EUR'
        ORDER BY total_price, begin_date
        INTO TABLE @DATA(res_8_3)
        UP TO 10 ROWS.

   et_travel_ids_task8_3 = res_8_3.

  ENDMETHOD.


  METHOD zif_abap_course_basics~scrabble_score.
    DATA(alphabet_string) = |abcdefghijklmnopqrstuvwxyz|.
    DATA(word_length) = STRLEN( iv_word ).
    DATA word_char TYPE string.
    DATA position_found TYPE i.
    DATA index TYPE i VALUE 0.

    "normalize input string since it can contain capital letters but we're ready to match against lowcase only
    DATA(modified_iv_word) = to_lower( iv_word ).

    WHILE index < word_length.
        word_char = modified_iv_word+index(1).

        "check if we have chars in input string different from alphabet letters
        IF alphabet_string NS word_char.
            rv_result = -1.
            EXIT.
        ENDIF.

        FIND word_char IN alphabet_string MATCH OFFSET position_found.

        IF sy-subrc = 0.
            "found -> offset + 1 will be the real position in alphabet
            rv_result += position_found + 1.
        ENDIF.

        index = index + 1.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.
