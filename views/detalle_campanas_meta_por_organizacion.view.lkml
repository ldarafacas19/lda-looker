
view: detalle_campanas_meta_por_organizacion {
  derived_table: {
    sql: SELECT
          DATE_TRUNC(CAST(date_start AS DATE), DAY) AS day,
          campaign_name,
          adset_name,
          ad_name,
          SUM(purchase) AS total_purchase,
          SAFE_DIVIDE(SUM(spend), SUM(purchase)) AS CPA
      FROM
          `linnda-tech.lda_base_data.meta_ads`
      GROUP BY
          day,
          campaign_name,
          adset_name,
          ad_name
      ORDER BY
          day,
          campaign_name,
          adset_name,
          ad_name ;;
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

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}.adset_name ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name ;;
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
        day,
  campaign_name,
  adset_name,
  ad_name,
  total_purchase,
  cpa
    ]
  }
}
