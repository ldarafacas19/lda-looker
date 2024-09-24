view: gasto_meta {
  derived_table: {
    sql: SELECT
          DATE_TRUNC(CAST(date_start AS DATE), DAY) AS day,
          organization_name,
          SUM(spend) AS total_spend
      FROM
          `linnda-tech.lda_base_data.meta_ads`
      GROUP BY
          day,
          organization_name
      ORDER BY
          day,
          organization_name ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.day ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: total_spend {
    type: number
    sql: ${TABLE}.total_spend ;;
  }

  set: detail {
    fields: [
        day,
  organization_name,
  total_spend
    ]
  }
}
