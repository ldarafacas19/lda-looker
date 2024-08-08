view: google_ads {
  sql_table_name: `lda_base_data.google_ads` ;;

  dimension: ad_group_id {
    type: number
    sql: ${TABLE}.ad_group_id ;;
  }
  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.ad_group_name ;;
  }
  dimension: all_conversions_add_to_cart {
    type: number
    sql: ${TABLE}.all_conversions_add_to_cart ;;
  }
  dimension: all_conversions_checkout {
    type: number
    sql: ${TABLE}.all_conversions_checkout ;;
  }
  dimension: all_conversions_other_event {
    type: number
    sql: ${TABLE}.all_conversions_other_event ;;
  }
  dimension: all_conversions_purchase {
    type: number
    sql: ${TABLE}.all_conversions_purchase ;;
  }
  dimension: all_conversions_value_add_to_cart {
    type: number
    sql: ${TABLE}.all_conversions_value_add_to_cart ;;
  }
  dimension: all_conversions_value_checkout {
    type: number
    sql: ${TABLE}.all_conversions_value_checkout ;;
  }
  dimension: all_conversions_value_other_event {
    type: number
    sql: ${TABLE}.all_conversions_value_other_event ;;
  }
  dimension: all_conversions_value_purchase {
    type: number
    sql: ${TABLE}.all_conversions_value_purchase ;;
  }
  dimension: all_conversions_value_web_visits {
    type: number
    sql: ${TABLE}.all_conversions_value_web_visits ;;
  }
  dimension: all_conversions_web_visits {
    type: number
    sql: ${TABLE}.all_conversions_web_visits ;;
  }
  dimension: ao {
    type: number
    sql: ${TABLE}.`año` ;;
  }
  dimension: average_cpc {
    type: number
    sql: ${TABLE}.average_cpc ;;
  }
  dimension: average_cpm {
    type: number
    sql: ${TABLE}.average_cpm ;;
  }
  dimension: cac {
    type: number
    sql: ${TABLE}.CAC ;;
  }
  dimension: campaign_end_date {
    type: string
    sql: ${TABLE}.campaign_end_date ;;
  }
  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }
  dimension: campaign_start_date {
    type: string
    sql: ${TABLE}.campaign_start_date ;;
  }
  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  dimension: conversions_add_to_cart {
    type: number
    sql: ${TABLE}.conversions_add_to_cart ;;
  }
  dimension: conversions_checkout {
    type: number
    sql: ${TABLE}.conversions_checkout ;;
  }
  dimension: conversions_other_event {
    type: number
    sql: ${TABLE}.conversions_other_event ;;
  }
  dimension: conversions_purchase {
    type: number
    sql: ${TABLE}.conversions_purchase ;;
  }
  dimension: conversions_value_add_to_cart {
    type: number
    sql: ${TABLE}.conversions_value_add_to_cart ;;
  }
  dimension: conversions_value_checkout {
    type: number
    sql: ${TABLE}.conversions_value_checkout ;;
  }
  dimension: conversions_value_other_event {
    type: number
    sql: ${TABLE}.conversions_value_other_event ;;
  }
  dimension: conversions_value_purchase {
    type: number
    sql: ${TABLE}.conversions_value_purchase ;;
  }
  dimension: conversions_value_web_visits {
    type: number
    sql: ${TABLE}.conversions_value_web_visits ;;
  }
  dimension: conversions_web_visits {
    type: number
    sql: ${TABLE}.conversions_web_visits ;;
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }
  dimension: cost_micros {
    type: number
    sql: ${TABLE}.cost_micros ;;
  }
  dimension: cost_per_conversion {
    type: number
    sql: ${TABLE}.cost_per_conversion ;;
  }
  dimension: ctr {
    type: number
    sql: ${TABLE}.ctr ;;
  }
  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }
  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  dimension: interactions_rate {
    type: number
    sql: ${TABLE}.interactions_rate ;;
  }
  dimension: keyword_info_text {
    type: string
    sql: ${TABLE}.keyword_info_text ;;
  }
  dimension: keyword_match_type {
    type: number
    sql: ${TABLE}.keyword_match_type ;;
  }
  dimension: match_type {
    type: string
    sql: ${TABLE}.match_type ;;
  }
  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }
  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }
  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }
  dimension: purchase_conversion {
    type: number
    sql: ${TABLE}.purchase_conversion ;;
  }
  dimension: roas {
    type: number
    sql: ${TABLE}.ROAS ;;
  }
  dimension: unique_identifier {
    type: string
    sql: ${TABLE}.unique_identifier ;;
  }
  dimension: value_per_conversion_add_to_cart {
    type: number
    sql: ${TABLE}.value_per_conversion_add_to_cart ;;
  }
  dimension: value_per_conversion_checkout {
    type: number
    sql: ${TABLE}.value_per_conversion_checkout ;;
  }
  dimension: value_per_conversion_other_event {
    type: number
    sql: ${TABLE}.value_per_conversion_other_event ;;
  }
  dimension: value_per_conversion_purchase {
    type: number
    sql: ${TABLE}.value_per_conversion_purchase ;;
  }
  dimension: value_per_conversion_web_visits {
    type: number
    sql: ${TABLE}.value_per_conversion_web_visits ;;
  }
  dimension: week {
    type: number
    sql: ${TABLE}.week ;;
  }
  measure: count {
    type: count
    drill_fields: [organization_name, ad_group_name, campaign_name]
  }
}
