*&---------------------------------------------------------------------*
*& Report zprog_demo1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprog_demo1.

class tc_get_input
  definition for testing risk level harmless.

  " demo on exception type of errors.
  private section.
    methods:
      do_get_input            for testing.
endclass.



class tc_get_input implementation.

  method do_get_input.
    " unconditional failed assertion can be raised via the method fail()
    cl_Abap_Unit_Assert=>fail( ).
  endmethod.

endclass.

CLASS main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_input
      RETURNING VALUE(input) TYPE string.
ENDCLASS.

CLASS main IMPLEMENTATION.

  METHOD get_input.
    cl_demo_input=>request( CHANGING field = input ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA(input) = main=>get_input( ).

  WRITE: / 'Input is', input.
