CLASS zcl_customer_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_customer_provider_factory .

  PUBLIC SECTION.
    INTERFACES zif_customer_provider .

    METHODS constructor
      IMPORTING
        !node_key TYPE snwd_node_key
      RAISING
        zcx_demo_bo .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA countries TYPE TABLE OF t005t.

    METHODS load_data
      IMPORTING
        !node_key TYPE snwd_node_key
      RAISING
        zcx_demo_bo .

    METHODS get_country_text
      RETURNING
        VALUE(country_text) TYPE landx50
      RAISING
        zcx_demo_bo .

ENDCLASS.

CLASS zcl_customer_provider IMPLEMENTATION.

  METHOD constructor.
    me->load_data( node_key ).
  ENDMETHOD.

  METHOD load_data.
    SELECT SINGLE bp~node_key, bp~bp_id, bp~company_name,
      ad~street, ad~city, ad~postal_code, ad~country
      FROM snwd_bpa AS bp
        INNER JOIN snwd_ad AS ad
        ON bp~address_guid = ad~node_key
      INTO CORRESPONDING FIELDS OF @me->zif_customer_provider~customer_data
      WHERE bp~node_key = @node_key.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'DEMO_CUSTOMER'
          bo_id   = |{ node_key }|.
    ENDIF.

    me->zif_customer_provider~customer_data-country_text = get_country_text( ).

  ENDMETHOD.

  METHOD get_country_text.
    TRY.
        country_text = countries[ land1 = me->zif_customer_provider~customer_data-country ]-landx50.
      CATCH cx_sy_itab_line_not_found.
        SELECT land1 landx50
          FROM t005t
          APPENDING CORRESPONDING FIELDS OF TABLE countries
          WHERE spras = sy-langu
          AND land1 = me->zif_customer_provider~customer_data-country.
        IF sy-subrc = 0.
          country_text = countries[ land1 = me->zif_customer_provider~customer_data-country ]-landx50.
        ENDIF.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
