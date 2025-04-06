*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS ppv_helper DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF travel_record,
           travel_id        TYPE /dmo/travel_id,
           agency_id        TYPE /dmo/agency_id,
             customer_id    TYPE /dmo/customer_id,
             begin_date     TYPE /dmo/begin_date,
             end_date       TYPE /dmo/end_date,
             booking_fee    TYPE /dmo/booking_fee,
             total_price    TYPE /dmo/total_price,
             currency_code  TYPE /dmo/currency_code,
             description    TYPE /dmo/description,
         END OF travel_record.

    DATA l_travel_record    TYPE travel_record.
    DATA travel_records TYPE TABLE OF travel_record.

    METHODS migrate_data_from_db.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS ppv_helper IMPLEMENTATION.

    METHOD migrate_data_from_db.
        SELECT * FROM ZTRAVEL_PPV INTO TABLE @DATA(lt_ztravel).
        DELETE ZTRAVEL_PPV FROM TABLE @lt_ztravel.
        COMMIT WORK AND WAIT.

        INSERT ZTRAVEL_PPV FROM
        ( SELECT FROM /dmo/travel
            FIELDS
             travel_id        AS travel_id,
             agency_id        AS agency_id,
             customer_id      AS customer_id,
             begin_date       AS begin_date,
             end_date         AS end_date,
             booking_fee      AS booking_fee,
             total_price      AS total_price,
             currency_code    AS currency_code,
             description      AS description,
             CASE status
           WHEN 'B' THEN  'A'  " ACCEPTED
           WHEN 'X'  THEN 'X' " CANCELLED
               ELSE 'O'         " open
          END                 AS overall_status,
             createdby        AS createdby,
             createdat        AS createdat,
             lastchangedby    AS last_changed_by,
             lastchangedat    AS last_changed_at
        ORDER BY travel_id ).

        COMMIT WORK AND WAIT.

    ENDMETHOD.

ENDCLASS.
