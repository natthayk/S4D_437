CLASS zcl_17_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    CONSTANTS c_agency_id TYPE /dmo/agency_id VALUE '070000'.
    CONSTANTS c_travel_id TYPE /dmo/travel_id VALUE '00000000'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_17_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*   DATA: lt_read_entity TYPE TABLE FOR READ RESULT z17_r_travel.
*   DATA: lt_read_import_entity TYPE TABLE FOR READ IMPORT z17_r_travel.
*
*   READ ENTITIES OF z17_r_travel
*      ENTITY Travel " z17_r_travel
*        ALL FIELDS
*        WITH   VALUE #( ( agencyid = c_agency_id
*                          travelid = c_travel_id ) )
**        RESULT DATA(travels)
*        RESULT lt_read_entity
*        FAILED DATA(failed).
*
*    IF failed IS NOT INITIAL.
*      out->write( `Error retrieving the travel` ).
*    ELSE.
*      MODIFY ENTITIES OF z17_r_travel
*        ENTITY Travel " /lrn/437b_r_travel
*        UPDATE
*        FIELDS ( description )
*        WITH   VALUE #( ( agencyid    = c_agency_id
*                          travelid    = c_travel_id
*                          description = `My new Description` ) )
*        FAILED failed.
*
*      IF failed IS INITIAL.
*        COMMIT ENTITIES.
*        out->write( `Description successfully updated` ).
*
*      ELSE.
*        ROLLBACK ENTITIES.
*        out->write( `Error updating the description` ).
*      ENDIF.
*    ENDIF.
*
    DATA lt_read_import_entity TYPE TABLE FOR READ IMPORT z17_r_travel.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_read_entity        TYPE TABLE FOR READ RESULT z17_r_travel.
    DATA lt_modify_entity      TYPE TABLE FOR UPDATE z17_r_travel.

    " 1) เตรียมคีย์ที่จะอ่าน (อ่านหลายแถวก็ได้)
    lt_read_import_entity = VALUE #( ( agencyid = c_agency_id  travelid = c_travel_id )
*      ( agencyid = '70041'      travelid = '0000000002' )
    ).

    " 2) เรียก READ ด้วยตารางคีย์ที่เตรียมไว้
    READ ENTITIES OF z17_r_travel
         ENTITY Travel
         FIELDS ( AgencyId TravelId Description BeginDate EndDate Status )  " หรือ ALL FIELDS
         WITH lt_read_import_entity
         RESULT lt_read_entity
         FAILED DATA(lt_failed).
    IF lt_failed IS NOT INITIAL.
      out->write( `Error retrieving the travel` ).
    ELSE.

      lt_modify_entity = VALUE #( ( agencyid    = c_agency_id
                                    travelid    = c_travel_id
                                    description = `My new Description` ) ).

      MODIFY ENTITIES OF z17_r_travel
             ENTITY Travel
             UPDATE
             FIELDS ( description )
*        WITH   VALUE #( ( agencyid    = c_agency_id
*                          travelid    = c_travel_id
*                          description = `My new Description` ) )
             WITH lt_modify_entity
             FAILED lt_failed.
      IF lt_failed IS INITIAL.
        COMMIT ENTITIES.
        out->write( `Description successfully updated` ).

      ELSE.
        ROLLBACK ENTITIES.
        out->write( `Error updating the description` ).
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
