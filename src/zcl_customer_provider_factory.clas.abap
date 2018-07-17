CLASS zcl_customer_provider_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_customer_factory_injector.
  PUBLIC SECTION.
    CLASS-METHODS get_customer_provider
      IMPORTING
                !node_key         TYPE snwd_node_key
      RETURNING VALUE(r_instance) TYPE REF TO zif_customer_provider
      RAISING
                zcx_demo_bo .

    CLASS-METHODS get_node_key_from_bp_id
      IMPORTING bp_id           TYPE snwd_partner_id
      RETURNING VALUE(node_key) TYPE snwd_node_key
      RAISING   zcx_demo_bo.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF instance_type,
        node_key TYPE snwd_node_key,
        instance TYPE REF TO zif_customer_provider,
      END OF instance_type .
    TYPES:
      instance_ttype TYPE TABLE OF instance_type .

    CLASS-DATA instances TYPE instance_ttype .
ENDCLASS.

CLASS zcl_customer_provider_factory IMPLEMENTATION.
  METHOD get_customer_provider.
    TRY.
        DATA(inst) = instances[ node_key = node_key ].
      CATCH cx_sy_itab_line_not_found.
        inst-node_key = node_key.
        inst-instance = NEW zcl_customer_provider( inst-node_key ).
        APPEND inst TO instances.
    ENDTRY.

    r_instance ?= inst-instance.

  ENDMETHOD.

  METHOD get_node_key_from_bp_id.
    DATA: lv_bp_id TYPE snwd_partner_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = bp_id
      IMPORTING
        output = lv_bp_id.

    LOOP AT instances REFERENCE INTO DATA(inst).
      IF inst->instance->customer_data-bp_id = lv_bp_id.
        node_key = inst->instance->customer_data-node_key.
        RETURN.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE node_key
      FROM snwd_bpa
      INTO @node_key
      WHERE bp_id = @lv_bp_id.
    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'Customer' ##NO_TEXT
          bo_id   = |{ bp_id }|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
