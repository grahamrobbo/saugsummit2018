CLASS zcl_customer_factory_injector DEFINITION FOR TESTING "secure access only in test
  PUBLIC
  FINAL
  CREATE PRIVATE . "static class

  PUBLIC SECTION.
    CLASS-METHODS inject_customer_provider
      IMPORTING i_customer_provider TYPE REF TO zif_customer_provider.
    CLASS-METHODS reset_customer_providers.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_customer_factory_injector IMPLEMENTATION.
  METHOD inject_customer_provider.
    APPEND INITIAL LINE TO zcl_customer_provider_factory=>instances REFERENCE INTO DATA(inst).
    inst->node_key = i_customer_provider->customer_data-node_key.
    inst->instance = i_customer_provider.
  ENDMETHOD.

  METHOD reset_customer_providers.
    CLEAR zcl_customer_provider_factory=>instances.
  ENDMETHOD.

ENDCLASS.
