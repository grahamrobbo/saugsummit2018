CLASS ltd_customer_provider DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES zif_customer_provider PARTIALLY IMPLEMENTED.
    METHODS constructor
      IMPORTING !is_customer_data TYPE zif_customer_provider=>customer_type.
ENDCLASS.

CLASS ltd_customer_provider IMPLEMENTATION.

  METHOD constructor.
    zif_customer_provider~customer_data = is_customer_data.
  ENDMETHOD.

ENDCLASS.

* _____________________________________________________________________________

CLASS ltc_customer DEFINITION FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

  PRIVATE SECTION.
    CLASS-DATA test_customer_0 TYPE zif_customer_provider=>customer_type.

    DATA m_cut TYPE REF TO zif_customer.

    METHODS setup.

    METHODS teardown.

    METHODS check_all_properties  FOR TESTING RAISING cx_static_check.
    METHODS singleton_by_node_key FOR TESTING RAISING cx_static_check.
    METHODS singleton_by_bp_id    FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_customer IMPLEMENTATION.
  METHOD class_constructor.
    test_customer_0 = VALUE #(
            node_key = '00000000000000000000000000000000'
            bp_id = 'TESTY'
            company_name = 'The Test Company'
            street = '12 MyStreet Lane'
            city = 'My City'
            postal_code = '12345'
            country = 'MY'
            country_text = 'My Country'
    ).
  ENDMETHOD.

  METHOD setup.

    zcl_customer_factory_injector=>inject_customer_provider( NEW ltd_customer_provider( test_customer_0 ) ). "dependency lookup

    TRY.
        m_cut = zcl_customer=>get( test_customer_0-node_key ).
      CATCH cx_abap_invalid_value.
    ENDTRY.

  ENDMETHOD.

  METHOD teardown.
    zcl_customer_factory_injector=>reset_customer_providers( ).
  ENDMETHOD.

  METHOD check_all_properties.
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_node_key(  )
                                        exp = test_customer_0-node_key ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_bp_id(  )
                                        exp = test_customer_0-bp_id ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_company_name(  )
                                        exp = test_customer_0-company_name ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_street(  )
                                        exp = test_customer_0-street ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_city(  )
                                        exp = test_customer_0-city ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_postal_code(  )
                                        exp = test_customer_0-postal_code ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_country(  )
                                        exp = test_customer_0-country ).
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_country_text(  )
                                        exp = test_customer_0-country_text ).
  ENDMETHOD.

  METHOD singleton_by_node_key.
    "when
    DATA(customer) = zcl_customer=>get( m_cut->get_node_key(  ) ).

    "then
    cl_abap_unit_assert=>assert_equals( act = customer exp = m_cut ).
  ENDMETHOD.

  METHOD singleton_by_bp_id.
    "when
    DATA(customer) = zcl_customer=>get_using_bp_id( m_cut->get_bp_id(  ) ).

    "then
    cl_abap_unit_assert=>assert_equals( act = customer exp = m_cut ).
  ENDMETHOD.

ENDCLASS.
