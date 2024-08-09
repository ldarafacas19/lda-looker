view: google_ads {
  sql_table_name: `lda_base_data.google_ads` ;;

  # Flexible Hierarchical Composite Primary Key
  dimension: primary_key {
    primary_key: yes
    type: string
    sql: CONCAT(
      COALESCE(CAST(${TABLE}.campaign_id AS STRING), 'null'), '-',
      COALESCE(CAST(${TABLE}.ad_group_id AS STRING), 'null'), '-',
      COALESCE(${TABLE}.keyword_info_text, 'null'), '-',
      COALESCE(${TABLE}.match_type, 'null'), '-',
      ${TABLE}.date
    ) ;;
    hidden: yes
  }

  # Date Dimension
  dimension_group: ad {
    type: time
    timeframes: [date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
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

  dimension: ad_group_id {
    type: number
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.ad_group_name ;;
  }

  # Keyword Information
  dimension: keyword_info_text {
    type: string
    sql: ${TABLE}.keyword_info_text ;;
  }

  dimension: keyword_match_type {
    type: string
    sql: ${TABLE}.match_type ;;
  }

  # Granularity dimension
  dimension: data_granularity {
    type: string
    sql: CASE
           WHEN ${TABLE}.keyword_info_text IS NOT NULL AND ${TABLE}.match_type IS NOT NULL THEN 'Keyword'
           WHEN ${TABLE}.ad_group_id IS NOT NULL THEN 'Ad Group'
           WHEN ${TABLE}.campaign_id IS NOT NULL THEN 'Campaign'
           ELSE 'Account'
         END ;;
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

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    value_format_name: usd
  }

  dimension: ctr {
    type: number
    sql: ${TABLE}.ctr ;;
    value_format_name: percent_2
  }

  dimension: average_cpc {
    type: number
    sql: ${TABLE}.average_cpc ;;
    value_format_name: usd
  }

  dimension: average_cpm {
    type: number
    sql: ${TABLE}.average_cpm ;;
    value_format_name: usd
  }

  # Conversion Metrics
  dimension: conversions_purchase {
    type: number
    sql: ${TABLE}.conversions_purchase ;;
  }

  dimension: conversions_value_purchase {
    type: number
    sql: ${TABLE}.conversions_value_purchase ;;
    value_format_name: usd
  }

  dimension: roas {
    type: number
    sql: ${TABLE}.ROAS ;;
    value_format_name: decimal_2
  }

  # Other Conversion Metrics
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

  dimension: all_conversions_web_visits {
    type: number
    sql: ${TABLE}.all_conversions_web_visits ;;
  }

  # Organization Information
  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
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

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: average_ctr {
    type: average
    sql: ${ctr} ;;
    value_format_name: percent_2
  }

  measure: average_cpc_overall {
    type: number
    sql: ${total_cost} / NULLIF(${total_clicks}, 0) ;;
    value_format_name: usd
  }

  measure: average_cpm_overall {
    type: number
    sql: (${total_cost} / NULLIF(${total_impressions}, 0)) * 1000 ;;
    value_format_name: usd
  }

  measure: total_conversions {
    type: sum
    sql: ${conversions_purchase} ;;
  }

  measure: total_conversion_value {
    type: sum
    sql: ${conversions_value_purchase} ;;
    value_format_name: usd
  }

  measure: overall_roas {
    type: number
    sql: ${total_conversion_value} / NULLIF(${total_cost}, 0) ;;
    value_format_name: decimal_2
  }

  measure: conversion_rate {
    type: number
    sql: ${total_conversions} / NULLIF(${total_clicks}, 0) ;;
    value_format_name: percent_2
  }

  measure: cost_per_conversion {
    type: number
    sql: ${total_cost} / NULLIF(${total_conversions}, 0) ;;
    value_format_name: usd
  }

  measure: total_add_to_cart {
    type: sum
    sql: ${all_conversions_add_to_cart} ;;
  }

  measure: total_checkouts {
    type: sum
    sql: ${all_conversions_checkout} ;;
  }

  measure: total_other_conversions {
    type: sum
    sql: ${all_conversions_other_event} ;;
  }

  measure: total_web_visits {
    type: sum
    sql: ${all_conversions_web_visits} ;;
  }

  # Sets
  set: detail {
    fields: [
      campaign_id,
      campaign_name,
      ad_group_id,
      ad_group_name,
      keyword_info_text,
      keyword_match_type,
      ad_date,
      data_granularity,
      impressions,
      clicks,
      cost,
      ctr,
      average_cpc,
      conversions_purchase,
      conversions_value_purchase,
      roas,
      organization_name
    ]
  }
}
