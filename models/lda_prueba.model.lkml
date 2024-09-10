connection: "linnda_bq"

# include all the views
include: "/views/**/*.view.lkml"
include: "/**/*.dashboard"

datagroup: lda_prueba_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: lda_prueba_default_datagroup

explore: analysis_ventas_por_hora_dia_de_la_semana_mes {}

explore: reporteria_normal {}

explore: reporteria_forecast {}

explore: incrementalidad {}

explore: mericas_generales_negocio_new_users_reteined_users_meta_spend_google_spend_revenue_per_segment {}

explore: gasto_meta  {}

explore: resumen_meta_por_organizacion {}

explore: detalle_campanas_meta_por_organizacion {}

explore: sales {
  label: "Sales and Customer Analysis"
  description: "Analyze sales data with customer RFM metrics and advertising performance"

 # access_filter: {
#    field: sales.organization_id
#    user_attribute: organization_id
#  }

  join: rfm {
    type: left_outer
    relationship: many_to_one
    sql_on: sql_on: ${sales.organization_id} = ${rfm.organization_id} AND (${sales.user_id} = ${rfm.user_id} OR ${sales.email} = ${rfm.email}) ;;
    fields: [rfm.recency, rfm.frequency, rfm.monetary, rfm.rfm_score, rfm.segment, rfm.loyalty_index]
  }
}

explore: rfm {
  label: "Customer RFM Analysis"
  description: "Analyze customer segments based on Recency, Frequency, and Monetary value"

  access_filter: {
    field: rfm.organization_id
    user_attribute: organization_id
  }

  join: sales {
    type: left_outer
    relationship: one_to_many
    sql_on: ${rfm.organization_id} = ${sales.organization_id} AND (${rfm.user_id} = ${sales.user_id} OR ${rfm.email} = ${sales.email}) ;;
    # fields: [sales.total_sales, sales.total_units_sold, sales.average_order_value]
  }
}

explore: meta_ads {}

explore: google_ads {}
