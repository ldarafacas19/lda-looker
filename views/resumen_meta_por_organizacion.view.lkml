
view: resumen_meta_por_organizacion {
  derived_table: {
    sql: SELECT
          DATE_TRUNC(CAST(date_start AS DATE), MONTH) AS month,
          organization_name,
          SUM(spend) AS total_spend,
          SUM(purchase) AS total_purchase,
          SAFE_DIVIDE(SUM(spend), SUM(purchase)) AS CPA
      FROM
          `linnda-tech.lda_base_data.meta_ads`
      GROUP BY
          month,
          organization_name
      ORDER BY
          month,
          organization_name ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: month {
    type: date
    datatype: date
    sql: ${TABLE}.month ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: total_spend {
    type: number
    sql: ${TABLE}.total_spend ;;
  }

  dimension: total_purchase {
    type: number
    sql: ${TABLE}.total_purchase ;;
  }

  dimension: cpa {
    type: number
    sql: ${TABLE}.CPA ;;
  }

  set: detail {
    fields: [
        month,
  organization_name,
  total_spend,
  total_purchase,
  cpa
    ]
  }
}
