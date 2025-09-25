CLASS zcm_17_travel DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF issue_message,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '100',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF issue_message.

    CONSTANTS:
      BEGIN OF cancel_success,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '120',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cancel_success .
    CONSTANTS:
      BEGIN OF already_canceled,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '130',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_canceled .
    CONSTANTS:
      BEGIN OF field_empty,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '200',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF field_empty .
    CONSTANTS:
      BEGIN OF customer_not_exist,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '210',
        attr1 TYPE scx_attrname VALUE 'CUSTOMERID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_not_exist .
    CONSTANTS:
      BEGIN OF dates_wrong_sequence,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '220',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF dates_wrong_sequence .
    CONSTANTS:
      BEGIN OF begin_date_past,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '230',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_past .
    CONSTANTS:
      BEGIN OF end_date_past,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '240',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_past .
    CONSTANTS:
      BEGIN OF flight_date_past,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '310',
        attr1 TYPE scx_attrname VALUE ' ',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_date_past .
    CONSTANTS:
      BEGIN OF flight_date_before_begin,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '320',
        attr1 TYPE scx_attrname VALUE ' ',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_date_before_begin .
    CONSTANTS:
      BEGIN OF flight_not_exist,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '330',
        attr1 TYPE scx_attrname VALUE 'CARRIERID',
        attr2 TYPE scx_attrname VALUE 'CONNECTIONID',
        attr3 TYPE scx_attrname VALUE 'FLIGHTDATE_TXT',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_not_exist .
    CONSTANTS:
      BEGIN OF class_not_exist,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '500',
        attr1 TYPE scx_attrname VALUE 'CLASSID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF class_not_exist .

    METHODS constructor
      IMPORTING
        textid       LIKE if_t100_message=>t100key
        severity     LIKE if_abap_behv_message=>m_severity OPTIONAL
        travelid     TYPE /dmo/travel_id OPTIONAL
        begindate    TYPE /dmo/begin_date OPTIONAL
        customerid   TYPE /dmo/customer_id OPTIONAL
        carrierid    TYPE /dmo/carrier_id OPTIONAL
        connectionid TYPE /dmo/connection_id OPTIONAL
        flightdate   TYPE /dmo/flight_date OPTIONAL
        classid      TYPE /lrn/class_id OPTIONAL.

    DATA travelid       TYPE /dmo/travel_id READ-ONLY .
    DATA begindate_txt  TYPE c LENGTH 10 READ-ONLY .
    DATA customerid     TYPE /dmo/customer_id READ-ONLY .
    DATA carrierid      TYPE /dmo/carrier_id READ-ONLY .
    DATA connectionid   TYPE /dmo/connection_id READ-ONLY .
    DATA flightdate_txt TYPE c LENGTH 10 READ-ONLY .
    DATA         classid      TYPE /lrn/class_id READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_17_travel IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
*    previous = previous
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF severity IS INITIAL.
      if_abap_behv_message~m_severity = if_abap_behv_message~severity-error.
    ELSE.
      if_abap_behv_message~m_severity = severity.
    ENDIF.

    me->travelid = travelid.
    me->begindate_txt  = |{ begindate DATE = USER }|.
    me->customerid     =  customerid.
    me->carrierid      = carrierid.
    me->connectionid   = connectionid.
    me->flightdate_txt = |{ flightdate DATE = USER }|.
    me->classid        = classid.
  ENDMETHOD.
ENDCLASS.
