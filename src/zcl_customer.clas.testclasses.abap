CLASS ltd_customer_provider DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES zif_customer_provider PARTIALLY IMPLEMENTED.
    METHODS constructor
      IMPORTING !is_customer_data TYPE zif_customer_provider=>customer_type.

  PRIVATE SECTION.
    DATA customer_data TYPE zif_customer_provider=>customer_type.

ENDCLASS.

CLASS ltd_customer_provider IMPLEMENTATION.

  METHOD constructor.
    customer_data = is_customer_data.
  ENDMETHOD.

  METHOD zif_customer_provider~get_bp_id.
    bp_id = customer_data-bp_id.
  ENDMETHOD.

  METHOD zif_customer_provider~get_city.
    city = customer_data-city.
  ENDMETHOD.

  METHOD zif_customer_provider~get_company_name.
    company_name = customer_data-company_name.
  ENDMETHOD.

  METHOD zif_customer_provider~get_country.
    country = customer_data-country.
  ENDMETHOD.

  METHOD zif_customer_provider~get_country_text.
    country_text = customer_data-country_text.
  ENDMETHOD.

  METHOD zif_customer_provider~get_node_key.
    node_key = customer_data-node_key.
  ENDMETHOD.

  METHOD zif_customer_provider~get_postal_code.
    postal_code = customer_data-postal_code.
  ENDMETHOD.

  METHOD zif_customer_provider~get_street.
    street = customer_data-street.
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

    METHODS setup RAISING cx_static_check.

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
    cl_abap_unit_assert=>assert_equals( act = m_cut->get_address(  )
                                        exp = |{ test_customer_0-street }, { test_customer_0-city } { test_customer_0-postal_code }, { test_customer_0-country_text }| ).
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

CLASS ltc_customer2 DEFINITION FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

  PRIVATE SECTION.
    CLASS-DATA test_customer_0 TYPE zif_customer_provider=>customer_type.

    DATA m_cut TYPE REF TO zif_customer.

    METHODS setup RAISING cx_static_check.

    METHODS teardown.

    METHODS check_all_properties  FOR TESTING RAISING cx_static_check.
    METHODS singleton_by_node_key FOR TESTING RAISING cx_static_check.
    METHODS singleton_by_bp_id    FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_customer2 IMPLEMENTATION.
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

    "create test double object
    DATA lo_customer_provider_double TYPE REF TO zif_customer_provider.
    lo_customer_provider_double ?= cl_abap_testdouble=>create( 'ZIF_CUSTOMER_PROVIDER' ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-bp_id ).
    lo_customer_provider_double->get_bp_id( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-node_key ).
    lo_customer_provider_double->get_node_key( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-company_name ).
    lo_customer_provider_double->get_company_name( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-street ).
    lo_customer_provider_double->get_street( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-city ).
    lo_customer_provider_double->get_city( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-postal_code ).
    lo_customer_provider_double->get_postal_code( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-country ).
    lo_customer_provider_double->get_country( ).

    cl_abap_testdouble=>configure_call( lo_customer_provider_double )->returning( test_customer_0-country_text ).
    lo_customer_provider_double->get_country_text( ).

    zcl_customer_factory_injector=>inject_customer_provider( lo_customer_provider_double ). "dependency lookup

    m_cut = zcl_customer=>get( test_customer_0-node_key ).

  ENDMETHOD.

  METHOD teardown.
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

    cl_abap_unit_assert=>assert_equals( act = m_cut->get_address(  )
                                        exp = |{ test_customer_0-street }, { test_customer_0-city } { test_customer_0-postal_code }, { test_customer_0-country_text }| ).

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
