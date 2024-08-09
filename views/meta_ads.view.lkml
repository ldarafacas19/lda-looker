view: meta_ads {
  sql_table_name: `lda_base_data.meta_ads` ;;

  # Dimensions
  dimension: primary_key {
    primary_key: yes
    type: string
    sql: CONCAT(${TABLE}.date_start, '-', ${TABLE}.ad_id) ;;
  }

  # Ad Information
  dimension: ad_id {
    type: number
    sql: ${TABLE}.ad_id ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name ;;
  }

  dimension: ad_status {
    type: string
    sql: ${TABLE}.ad_status ;;
  }

  dimension: ad_deep_link {
    type: string
    sql: ${TABLE}.ad_deep_link ;;
  }

  dimension: body {
    type: string
    sql: ${TABLE}.body ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: image_url {
    type: string
    sql: ${TABLE}.image_url ;;
  }

  dimension: call_to_action_type {
    type: string
    sql: ${TABLE}.call_to_action_type ;;
  }

  # Campaign Structure
  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: adset_id {
    type: number
    sql: ${TABLE}.adset_id ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}.adset_name ;;
  }

  # Account Information
  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}.account_name ;;
  }

  dimension: account_currency {
    type: string
    sql: ${TABLE}.account_currency ;;
  }

  # Date Dimensions
  dimension_group: ad_date {
    type: time
    timeframes: [date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_start ;;
  }

  # Performance Metrics
  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: spend {
    type: number
    sql: ${TABLE}.spend ;;
    value_format_name: usd
  }

  dimension: reach {
    type: number
    sql: ${TABLE}.reach ;;
  }

  # Calculated Dimensions
  dimension: ctr {
    type: number
    sql: ${TABLE}.ctr ;;
    value_format_name: percent_2
  }

  dimension: cpc {
    type: number
    sql: ${TABLE}.cpc ;;
    value_format_name: usd
  }

  dimension: cpm {
    type: number
    sql: ${TABLE}.cpm ;;
    value_format_name: usd
  }

  # Conversion Metrics
  dimension: purchase {
    type: number
    sql: ${TABLE}.purchase ;;
  }

  dimension: purchase_value {
    type: number
    sql: ${TABLE}.purchase_value ;;
    value_format_name: usd
  }

  dimension: roas {
    type: number
    sql: ${TABLE}.ROAS ;;
    value_format_name: decimal_2
  }

  # Measures
  measure: total_impressions {
    type: sum
    sql: ${impressions} ;;
  }

  measure: total_clicks {
    type: sum
    sql: ${clicks} ;;
  }

  measure: total_spend {
    type: sum
    sql: ${spend} ;;
    value_format_name: usd
  }

  measure: total_reach {
    type: sum
    sql: ${reach} ;;
  }

  measure: total_purchases {
    type: sum
    sql: ${purchase} ;;
  }

  measure: total_purchase_value {
    type: sum
    sql: ${purchase_value} ;;
    value_format_name: usd
  }

  measure: average_ctr {
    type: average
    sql: ${ctr} ;;
    value_format_name: percent_2
  }

  measure: average_cpc {
    type: average
    sql: ${cpc} ;;
    value_format_name: usd
  }

  measure: average_cpm {
    type: average
    sql: ${cpm} ;;
    value_format_name: usd
  }

  measure: overall_roas {
    type: number
    sql: ${total_purchase_value} / NULLIF(${total_spend}, 0) ;;
    value_format_name: decimal_2
  }

  # Sets
  set: detail {
    fields: [
      ad_id,
      ad_name,
      campaign_name,
      adset_name,
      ad_date_date,
      impressions,
      clicks,
      spend,
      purchase,
      purchase_value,
      ctr,
      cpc,
      roas
    ]
  }
}
