*CLASS lsc_z17_r_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.
*
*  PROTECTED SECTION.
*    METHODS save_modified REDEFINITION.
*
*  PRIVATE SECTION.
*    METHODS
*      map_message
*        IMPORTING i_msg        TYPE symsg
*        RETURNING VALUE(r_msg) TYPE REF TO if_abap_behv_message.
*
*ENDCLASS.
*
*
*CLASS lsc_z17_r_travel IMPLEMENTATION.
*  METHOD save_modified.
*    DATA(model) = NEW zcl_s4d437_tritem( i_table_name = 'Z17_TRITEM' ).
*
*    LOOP AT delete-item ASSIGNING FIELD-SYMBOL(<item_d>).
*
*      " Without message handling
*      "        model->delete_item( i_uuid = <item_d>-itemuuid ).
*      " With message handling
*      DATA(msg_d) = model->delete_item( i_uuid = <item_d>-itemuuid ).
*
*      IF msg_d IS NOT INITIAL.
*        APPEND VALUE #( %tky-itemuuid = <item_d>-itemuuid
*                        %msg          = map_message( msg_d ) )
*               TO reported-item.
*      ENDIF.
*
*    ENDLOOP.
*
*    LOOP AT create-item ASSIGNING FIELD-SYMBOL(<item_c>).
*
*      DATA(msg_c) = model->create_item( i_item = CORRESPONDING #( <item_c> MAPPING FROM ENTITY ) ).
*
*      IF msg_c IS NOT INITIAL.
*        APPEND VALUE #( %tky-itemuuid = <item_c>-itemuuid
*                        %msg          = map_message( msg_c ) )
*               TO reported-item.
*      ENDIF.
*
*    ENDLOOP.
*
*    LOOP AT update-item ASSIGNING FIELD-SYMBOL(<item_u>).
*
**       model->update_item(
**               i_item  = CORRESPONDING #( <item_u> MAPPING FROM ENTITY )
**               i_itemx = CORRESPONDING #( <item_u> MAPPING FROM ENTITY
**                                                   USING CONTROL )
**             ).
*
*      DATA(msg_u) = model->update_item( i_item  = CORRESPONDING #( <item_u> MAPPING FROM ENTITY )
*                                        i_itemx = CORRESPONDING #( <item_u> MAPPING FROM ENTITY
*                                                                            USING CONTROL ) ).
*
*      IF msg_u IS NOT INITIAL.
*        APPEND VALUE #( %tky-itemuuid = <item_u>-itemuuid
*                        %msg          = map_message( msg_u ) )
*               TO reported-item.
*      ENDIF.
*
*    ENDLOOP.
*
*    " For Even Logic
*    IF create-travel IS NOT INITIAL.
*
*      " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*      DATA lt_eventin TYPE TABLE FOR EVENT z17_r_travel~TravelCreated.
*
*      lt_eventin = VALUE #( FOR ls_travel IN create-travel
*                            ( agencyid = ls_travel-AgencyId
*                              TravelId = ls_travel-TravelId
*                              origin   = 'Z17_R_TRAVEL' ) ).
*
**      RAISE ENTITY EVENT Z17_R_Travel~TravelCreated
**            FROM CORRESPONDING #( create-travel ).
***             FROM lt_eventin.
*      RAISE ENTITY EVENT Z17_R_Travel~TravelCreated
*            FROM VALUE #( FOR <new_travel> IN create-travel
*                          ( AgencyId = <new_travel>-AgencyId
*                            TravelId = <new_travel>-TravelId
*                            origin   = 'Z17_R_TRAVEL' ) ).
*    ENDIF.
*  ENDMETHOD.
*
*  METHOD map_message.
*    " Map message type to severity
*    DATA(severity) = SWITCH #( i_msg-msgty
*                               WHEN 'S' THEN if_abap_behv_message=>severity-success
*                               WHEN 'I' THEN if_abap_behv_message=>severity-information
*                               WHEN 'W' THEN if_abap_behv_message=>severity-warning
*                               WHEN 'E' THEN if_abap_behv_message=>severity-error
*                               ELSE          if_abap_behv_message=>severity-none ).
*
** More old-fashioned alternative with CASE ... ENDCASE structure
**    DATA severity TYPE if_abap_behv_message=>t_severity.
**    CASE i_msg-msgty.
**      WHEN 'S'.
**        severity = if_abap_behv_message=>severity-success.
**      WHEN 'I'.
**        severity = if_abap_behv_message=>severity-information.
**      WHEN 'W'.
**        severity = if_abap_behv_message=>severity-warning.
**      WHEN 'E'.
**        severity = if_abap_behv_message=>severity-error.
**      WHEN OTHERS.
**        severity = if_abap_behv_message=>severity-none.
**    ENDCASE.
*
*    " create Message object
*    r_msg = new_message( id       = i_msg-msgid
*                         number   = i_msg-msgno
*                         severity = severity
*                         v1       = i_msg-msgv1
*                         v2       = i_msg-msgv2
*                         v3       = i_msg-msgv3
*                         v4       = i_msg-msgv4 ).
*  ENDMETHOD.
*ENDCLASS.


CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

*    METHODS cancel_travel FOR MODIFY
*      IMPORTING keys FOR ACTION Travel~cancel_travel.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR Travel RESULT result.
    METHODS validateBeginDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateBeginDate.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDateSequence FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDateSequence.

    METHODS validateDescription FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDescription.

    METHODS validateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateEndDate.
    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~determineStatus.
    METHODS cancel_travel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~cancel_travel RESULT result.
    METHODS determineDuration FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~determineDuration.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

ENDCLASS.


CLASS lhc_Travel IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(agencyid) = /lrn/cl_s4d437_model=>get_agency_by_user( ).

    mapped-travel = CORRESPONDING #( entities ).

    LOOP AT mapped-travel ASSIGNING FIELD-SYMBOL(<mapping>).
      <mapping>-agencyid = agencyid.
      <mapping>-travelid = /lrn/cl_s4d437_model=>get_next_travelid( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( status begindate enddate changedby )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      APPEND CORRESPONDING #( <travel> ) TO result
             ASSIGNING FIELD-SYMBOL(<result>).

*      IF <travel>-%is_draft = if_abap_behv=>mk-on. " Special Handling for Drafts
*        " Try to Read BeginDate and EndDate from active instance
*        READ ENTITIES OF z17_r_travel IN LOCAL MODE
*        ENTITY travel
*          FIELDS ( begindate enddate )
*          WITH VALUE #( ( %key = <travel>-%key
*                          %is_draft = if_abap_behv=>mk-off   "optional
*                      ) )
*          RESULT DATA(travels_activ).
*        IF travels_activ IS NOT INITIAL.
*          " edit draft (active instance exists)
*          " use BeginDate and EndDate in active instance for feature control
*          <travel>-begindate = travels_activ[ 1 ]-begindate.
*          <travel>-enddate   = travels_activ[ 1 ]-enddate.
*        ELSE.
*          " new draft - use initial values for feature control.
*          CLEAR <travel>-begindate.
*          CLEAR <travel>-enddate.
*        ENDIF.
*      ENDIF.

*      " Special Handling for Edit Drafts (ChangedBy not initial)
*      IF <travel>-%is_draft IS NOT INITIAL and <travel>-ChangedBy is not initial.
*      " Read BeginDate and EndDate from active instance
*        READ ENTITIES OF /lrn/437d_r_travel IN LOCAL MODE
*        ENTITY travel
*          FIELDS ( begindate enddate )
*          WITH VALUE #( ( %key = <travel>-%key ) )
*          RESULT DATA(travels_activ).
*        IF travels_activ IS NOT INITIAL.
*        " use BeginDate and EndDate of active instance for feature control
*          <travel>-begindate = travels_activ[ 1 ]-begindate.
*          <travel>-enddate   = travels_activ[ 1 ]-enddate.
*        ENDIF.
*      ENDIF.

      IF    <travel>-status = 'C'
         OR (     <travel>-enddate IS NOT INITIAL
              AND <travel>-enddate  < cl_abap_context_info=>get_system_date( ) ).

        <result>-%update               = if_abap_behv=>fc-o-disabled.
        <result>-%action-cancel_travel = if_abap_behv=>fc-o-disabled.

      ELSE.

        <result>-%update               = if_abap_behv=>fc-o-enabled.
        <result>-%action-cancel_travel = if_abap_behv=>fc-o-enabled.

      ENDIF.

*      IF <travel>-begindate IS NOT INITIAL AND
*         <travel>-begindate < cl_abap_context_info=>get_system_date( ).
*
*        <result>-%field-CustomerId = if_abap_behv=>fc-f-read_only.
*        <result>-%field-begindate  = if_abap_behv=>fc-f-read_only.
*
*      ELSE.
*
*        <result>-%field-customerid = if_abap_behv=>fc-f-mandatory.
*        <result>-%field-begindate  = if_abap_behv=>fc-f-mandatory.
*
*      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*  METHOD cancel_travel.
*    READ ENTITIES OF z17_r_travel IN LOCAL MODE
*         ENTITY travel
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(travels).
*
*    LOOP AT travels INTO DATA(travel).
*
*      IF travel-status <> 'C'.
*
*        MODIFY ENTITIES OF z17_r_travel IN LOCAL MODE
*               ENTITY travel
*               UPDATE
*               FIELDS ( status )
*               WITH VALUE #( ( %tky   = travel-%tky
*                               status = 'C' ) )
*               REPORTED DATA(rpt).
*
*        APPEND LINES OF rpt-travel TO reported-travel.
*        " สำคัญ: คืน key ของอินสแตนซ์ที่แก้ เพื่อให้ FE รับ post-image  UI รีเฟรชอินสแตนซ์
*        APPEND VALUE #( %tky = travel-%tky ) TO result.
*
*      ELSE.
*        APPEND VALUE #( %tky = travel-%tky )
*               TO failed-travel.
*        APPEND VALUE #( %tky = travel-%tky
*                        %msg = NEW zcm_17_travel( textid = /lrn/cm_s4d437=>already_canceled ) )
*               TO reported-travel.
*
*        " ส่งกลับ $self ด้วยก็ได้ จะทำให้ UI รีเฟรชอินสแตนซ์นี้เหมือนกัน
*        APPEND VALUE #( %tky = travel-%tky ) TO result.
*
*      ENDIF.
*
*    ENDLOOP.
*  ENDMETHOD.
  METHOD cancel_travel.
    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY Travel
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels INTO DATA(travel).

      IF travel-status = 'C'.
        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /lrn/cm_s4d437( textid = /lrn/cm_s4d437=>already_canceled ) )
               TO reported-travel.
        " ส่งกลับ $self ด้วยก็ได้ จะทำให้ UI รีเฟรชอินสแตนซ์นี้เหมือนกัน
        APPEND VALUE #( %tky = travel-%tky ) TO result.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF z17_r_travel IN LOCAL MODE
             ENTITY Travel
             UPDATE FIELDS ( status )
             WITH VALUE #( ( %tky = travel-%tky status = 'C' ) )
             REPORTED DATA(rpt).

      APPEND LINES OF rpt-travel TO reported-travel.

      " 2) อ่าน post-image
      READ ENTITIES OF z17_r_travel IN LOCAL MODE
           ENTITY Travel
           ALL FIELDS
           WITH VALUE #( ( %tky = travel-%tky ) )
           RESULT DATA(post).

      " 3) ใส่ post-image ลง result-%param
      APPEND VALUE #( %tky   = travel-%tky
                      %param = CORRESPONDING #( post[ 1 ] ) ) " ถ้ากังวลเรื่องฟิลด์เกิน ให้เลือกเฉพาะที่แสดง
             TO result.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_features.
  ENDMETHOD.

  METHOD validateBeginDate.
    CONSTANTS c_area TYPE string VALUE `BEGINDATE`.

    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( begindate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      APPEND VALUE #( %tky        = <travel>-%tky
                      %state_area = c_area )
             TO reported-travel.
      IF <travel>-begindate IS INITIAL.

        APPEND VALUE #( %tky = <travel>-%tky )
               TO failed-travel.

        APPEND VALUE #( %tky               = <travel>-%tky
                        %msg               = NEW /lrn/cm_s4d437( /lrn/cm_s4d437=>field_empty )
                        %element-begindate = if_abap_behv=>mk-on
                        %state_area        = c_area )
               TO reported-travel.
      ELSEIF <travel>-begindate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky = <travel>-%tky )
               TO failed-travel.

        APPEND VALUE #( %tky               = <travel>-%tky
                        %msg               = NEW /lrn/cm_s4d437( textid = /lrn/cm_s4d437=>begin_date_past )
                        %element-begindate = if_abap_behv=>mk-on
                        %state_area        = c_area )
               TO reported-travel.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomer.
    CONSTANTS c_area TYPE string VALUE `CUST`.

    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( customerid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      APPEND VALUE #( %tky        = <travel>-%tky
                      %state_area = c_area )
             TO reported-travel.

      IF <travel>-customerid IS INITIAL.

        APPEND VALUE #( %tky = <travel>-%tky )
               TO failed-travel.

        APPEND VALUE #( %tky                = <travel>-%tky
                        %msg                = NEW /lrn/cm_s4d437( /lrn/cm_s4d437=>field_empty )
                        %element-customerid = if_abap_behv=>mk-on
                        %state_area         = c_area )
               TO reported-travel.
      ELSE.

        SELECT SINGLE FROM /DMO/I_Customer
          FIELDS customerid
          WHERE customerid = @<travel>-customerid
          " TODO: variable is assigned but never used (ABAP cleaner)
          INTO @DATA(dummy).

        IF sy-subrc <> 0.

          APPEND VALUE #( %tky = <travel>-%tky )
                 TO failed-travel.

          APPEND VALUE #( %tky                = <travel>-%tky
                          %msg                = NEW /lrn/cm_s4d437( textid     = /lrn/cm_s4d437=>customer_not_exist
                                                                    customerid = <travel>-customerid )
                          %element-customerid = if_abap_behv=>mk-on
                          %state_area         = c_area )
                 TO reported-travel.

        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDateSequence.
  ENDMETHOD.

  METHOD validateDescription.
    CONSTANTS c_area TYPE string VALUE `DESC`.

    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( description )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      APPEND VALUE #( %tky        = <travel>-%tky
                      %state_area = c_area )
             TO reported-travel.

      IF <travel>-description IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = <travel>-%tky )
             TO failed-travel.

      APPEND VALUE #( %tky                 = <travel>-%tky
                      %msg                 = NEW /lrn/cm_s4d437( /lrn/cm_s4d437=>field_empty )
                      %element-description = if_abap_behv=>mk-on
                      %state_area          = c_area )
             TO reported-travel.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEndDate.
    CONSTANTS c_area TYPE string VALUE `ENDDATE`.

    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( enddate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      APPEND VALUE #( %tky        = <travel>-%tky
                      %state_area = c_area )
             TO reported-travel.

      IF <travel>-enddate IS INITIAL.

        APPEND VALUE #( %tky = <travel>-%tky )
               TO failed-travel.

        APPEND VALUE #( %tky             = <travel>-%tky
                        %msg             = NEW /lrn/cm_s4d437( /lrn/cm_s4d437=>field_empty )
                        %element-enddate = if_abap_behv=>mk-on
                        %state_area      = c_area )
               TO reported-travel.
      ELSEIF <travel>-enddate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky = <travel>-%tky )
               TO failed-travel.

        APPEND VALUE #( %tky             = <travel>-%tky
                        %msg             = NEW /lrn/cm_s4d437( textid = /lrn/cm_s4d437=>end_date_past )
                        %element-enddate = if_abap_behv=>mk-on
                        %state_area      = c_area )
               TO reported-travel.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD determineStatus.
    READ ENTITIES OF Z17_R_Travel IN LOCAL MODE
         ENTITY Travel FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).
    DELETE travels WHERE Status IS NOT INITIAL.
    IF travels IS INITIAL.
      RETURN.
    ENDIF.
    MODIFY ENTITIES OF z17_R_Travel IN LOCAL MODE
           ENTITY Travel UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN travels
                         ( %tky = key-%tky Status = 'N' ) ).
  ENDMETHOD.

  METHOD determineDuration.
    READ ENTITIES OF z17_r_travel IN LOCAL MODE
         ENTITY travel
         FIELDS ( begindate enddate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
      <travel>-duration = <travel>-enddate - <travel>-begindate.
    ENDLOOP.

    MODIFY ENTITIES OF z17_r_travel IN LOCAL MODE
           ENTITY travel
           UPDATE
           FIELDS ( duration )
           WITH CORRESPONDING #( travels ).
  ENDMETHOD.
ENDCLASS.
