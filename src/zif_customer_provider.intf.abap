INTERFACE zif_customer_provider
  PUBLIC .
  TYPES: BEGIN OF customer_type,
           node_key     TYPE snwd_node_key,
           bp_id        TYPE snwd_partner_id,
           company_name TYPE snwd_company_name,
           street       TYPE snwd_street,
           city         TYPE snwd_city,
           postal_code  TYPE snwd_postal_code,
           country      TYPE snwd_country,
           country_text TYPE zdemo_country_text,
         END OF customer_type.

  DATA: customer_data TYPE customer_type READ-ONLY.

ENDINTERFACE.
