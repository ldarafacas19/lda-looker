view: meta_ads {
  sql_table_name: `lda_base_data.meta_ads` ;;

  dimension: account_currency {
    type: string
    sql: ${TABLE}.account_currency ;;
  }
  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }
  dimension: account_name {
    type: string
    sql: ${TABLE}.account_name ;;
  }
  dimension: ad_deep_link {
    type: string
    sql: ${TABLE}.ad_deep_link ;;
  }
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
  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }
  dimension: add_to_cart_value {
    type: number
    sql: ${TABLE}.add_to_cart_value ;;
  }
  dimension: adset_id {
    type: number
    sql: ${TABLE}.adset_id ;;
  }
  dimension: adset_name {
    type: string
    sql: ${TABLE}.adset_name ;;
  }
  dimension: body {
    type: string
    sql: ${TABLE}.body ;;
  }
  dimension: cac {
    type: number
    sql: ${TABLE}.CAC ;;
  }
  dimension: call_to_action_type {
    type: string
    sql: ${TABLE}.call_to_action_type ;;
  }
  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }
  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  dimension: cpc {
    type: number
    sql: ${TABLE}.cpc ;;
  }
  dimension: cpm {
    type: number
    sql: ${TABLE}.cpm ;;
  }
  dimension: ctr {
    type: number
    sql: ${TABLE}.ctr ;;
  }
  dimension: date_start {
    type: string
    sql: ${TABLE}.date_start ;;
  }
  dimension: date_stop {
    type: string
    sql: ${TABLE}.date_stop ;;
  }
  dimension: image_url {
    type: string
    sql: ${TABLE}.image_url ;;
  }
  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  dimension: initiate_checkout {
    type: number
    sql: ${TABLE}.initiate_checkout ;;
  }
  dimension: initiate_checkout_value {
    type: number
    sql: ${TABLE}.initiate_checkout_value ;;
  }
  dimension: landing_page_view {
    type: number
    sql: ${TABLE}.landing_page_view ;;
  }
  dimension: landing_page_view_value {
    type: number
    sql: ${TABLE}.landing_page_view_value ;;
  }
  dimension: link {
    type: string
    sql: ${TABLE}.link ;;
  }
  dimension: link_click {
    type: number
    sql: ${TABLE}.link_click ;;
  }
  dimension: link_click_value {
    type: number
    sql: ${TABLE}.link_click_value ;;
  }
  dimension: messaging_conversation_started_7d {
    type: number
    sql: ${TABLE}.messaging_conversation_started_7d ;;
  }
  dimension: messaging_conversation_started_7d_value {
    type: number
    sql: ${TABLE}.messaging_conversation_started_7d_value ;;
  }
  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }
  dimension: object_type {
    type: string
    sql: ${TABLE}.object_type ;;
  }
  dimension: objective {
    type: string
    sql: ${TABLE}.objective ;;
  }
  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }
  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }
  dimension: purchase {
    type: number
    sql: ${TABLE}.purchase ;;
  }
  dimension: purchase_conversion {
    type: number
    sql: ${TABLE}.purchase_conversion ;;
  }
  dimension: purchase_value {
    type: number
    sql: ${TABLE}.purchase_value ;;
  }
  dimension: reach {
    type: number
    sql: ${TABLE}.reach ;;
  }
  dimension: roas {
    type: number
    sql: ${TABLE}.ROAS ;;
  }
  dimension: spend {
    type: number
    sql: ${TABLE}.spend ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }
  dimension: unique_identifier {
    type: string
    sql: ${TABLE}.unique_identifier ;;
  }
  dimension: view_content {
    type: number
    sql: ${TABLE}.view_content ;;
  }
  dimension: view_content_value {
    type: number
    sql: ${TABLE}.view_content_value ;;
  }
  dimension: week {
    type: number
    sql: ${TABLE}.week ;;
  }
  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }
  measure: count {
    type: count
    drill_fields: [adset_name, organization_name, campaign_name, account_name, ad_name]
  }
}
