view: google_ads {
  sql_table_name: `lda_base_data.google_ads` ;;

  # Primary Key
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      COALESCE(CAST(${TABLE}.campaign_id AS STRING), 'null'), '-',
      COALESCE(CAST(${TABLE}.ad_group_id AS STRING), 'null'), '-',
      COALESCE(${TABLE}.keyword_info_text, 'null'), '-',
      COALESCE(${TABLE}.match_type, 'null'), '-',
      ${TABLE}.date
    ) ;;
    description: "Unique identifier for each ad performance record"
  }

  # Date Dimension
  dimension_group: ad {
    group_label: "Ad Performance Date"
    type: time
    timeframes: [date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
    description: "Date of the ad performance data"
  }

  # Campaign Structure
  dimension: campaign_id {
    group_label: "Campaign Structure"
    type: number
    sql: ${TABLE}.campaign_id ;;
    description: "Unique identifier for the campaign"
  }

  dimension: campaign_name {
    group_label: "Campaign Structure"
    type: string
    sql: ${TABLE}.campaign_name ;;
    description: "Name of the campaign"
  }

  dimension: ad_group_id {
    group_label: "Campaign Structure"
    type: number
    sql: ${TABLE}.ad_group_id ;;
    description: "Unique identifier for the ad group"
  }

  dimension: ad_group_name {
    group_label: "Campaign Structure"
    type: string
    sql: ${TABLE}.ad_group_name ;;
    description: "Name of the ad group"
  }

  # Keyword Information
  dimension: keyword_info_text {
    group_label: "Keyword Info"
    type: string
    sql: ${TABLE}.keyword_info_text ;;
    description: "Text of the keyword"
  }

  dimension: keyword_match_type {
    group_label: "Keyword Info"
    type: string
    sql: ${TABLE}.match_type ;;
    description: "Match type of the keyword (e.g., exact, phrase, broad)"
  }

  # Granularity dimension
  dimension: data_granularity {
    group_label: "Data Analysis"
    type: string
    sql: CASE
           WHEN ${TABLE}.keyword_info_text IS NOT NULL AND ${TABLE}.match_type IS NOT NULL THEN 'Keyword'
           WHEN ${TABLE}.ad_group_id IS NOT NULL THEN 'Ad Group'
           WHEN ${TABLE}.campaign_id IS NOT NULL THEN 'Campaign'
           ELSE 'Account'
         END ;;
    description: "Level of data granularity (Keyword, Ad Group, Campaign, or Account)"
  }

  # Performance Metrics
  dimension: impressions {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.impressions ;;
    description: "Number of times the ad was shown"
  }

  dimension: clicks {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.clicks ;;
    description: "Number of clicks on the ad"
  }

  dimension: cost {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.cost ;;
    value_format_name: usd
    description: "Cost of the ad"
  }

  dimension: ctr {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.ctr ;;
    value_format_name: percent_2
    description: "Click-through rate (Clicks / Impressions)"
  }

  dimension: average_cpc {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.average_cpc ;;
    value_format_name: usd
    description: "Average cost per click"
  }

  dimension: average_cpm {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.average_cpm ;;
    value_format_name: usd
    description: "Average cost per thousand impressions"
  }

  # Conversion Metrics
  dimension: conversions_purchase {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.conversions_purchase ;;
    description: "Number of purchase conversions"
  }

  dimension: conversions_value_purchase {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.conversions_value_purchase ;;
    value_format_name: usd
    description: "Value of purchase conversions"
  }

  dimension: roas {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.ROAS ;;
    value_format_name: decimal_2
    description: "Return on Ad Spend (Conversion Value / Cost)"
  }

  # Other Conversion Metrics
  dimension: all_conversions_add_to_cart {
    group_label: "Other Conversion Metrics"
    type: number
    sql: ${TABLE}.all_conversions_add_to_cart ;;
    description: "Number of add-to-cart events"
  }

  dimension: all_conversions_checkout {
    group_label: "Other Conversion Metrics"
    type: number
    sql: ${TABLE}.all_conversions_checkout ;;
    description: "Number of checkout events"
  }

  dimension: all_conversions_other_event {
    group_label: "Other Conversion Metrics"
    type: number
    sql: ${TABLE}.all_conversions_other_event ;;
    description: "Number of other conversion events"
  }

  dimension: all_conversions_web_visits {
    group_label: "Other Conversion Metrics"
    type: number
    sql: ${TABLE}.all_conversions_web_visits ;;
    description: "Number of web visit conversions"
  }

  # Organization Information
  dimension: organization_id {
    group_label: "Organization Info"
    type: string
    sql: ${TABLE}.organization_id ;;
    description: "Unique identifier for the organization"
  }

  dimension: organization_name {
    group_label: "Organization Info"
    type: string
    sql: ${TABLE}.organization_name ;;
    description: "Name of the organization"
  }

  # Measures
  measure: total_impressions {
    group_label: "Performance Totals"
    type: sum
    sql: ${impressions} ;;
    description: "Total number of ad impressions"
    drill_fields: [detail*]
  }

  measure: total_clicks {
    group_label: "Performance Totals"
    type: sum
    sql: ${clicks} ;;
    description: "Total number of ad clicks"
    drill_fields: [detail*]
  }

  measure: total_cost {
    group_label: "Performance Totals"
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
    description: "Total cost of ads"
    drill_fields: [detail*]
  }

  measure: average_ctr {
    group_label: "Performance Averages"
    type: average
    sql: ${ctr} ;;
    value_format_name: percent_2
    description: "Average click-through rate"
    drill_fields: [detail*]
  }

  measure: average_cpc_overall {
    group_label: "Performance Averages"
    type: number
    sql: ${total_cost} / NULLIF(${total_clicks}, 0) ;;
    value_format_name: usd
    description: "Overall average cost per click"
    drill_fields: [detail*]
  }

  measure: average_cpm_overall {
    group_label: "Performance Averages"
    type: number
    sql: (${total_cost} / NULLIF(${total_impressions}, 0)) * 1000 ;;
    value_format_name: usd
    description: "Overall average cost per thousand impressions"
    drill_fields: [detail*]
  }

  measure: total_conversions {
    group_label: "Conversion Totals"
    type: sum
    sql: ${conversions_purchase} ;;
    description: "Total number of purchase conversions"
    drill_fields: [detail*]
  }

  measure: total_conversion_value {
    group_label: "Conversion Totals"
    type: sum
    sql: ${conversions_value_purchase} ;;
    value_format_name: usd
    description: "Total value of purchase conversions"
    drill_fields: [detail*]
  }

  measure: overall_roas {
    group_label: "Conversion Metrics"
    type: number
    sql: ${total_conversion_value} / NULLIF(${total_cost}, 0) ;;
    value_format_name: decimal_2
    description: "Overall Return on Ad Spend"
    drill_fields: [detail*]
  }

  measure: conversion_rate {
    group_label: "Conversion Metrics"
    type: number
    sql: ${total_conversions} / NULLIF(${total_clicks}, 0) ;;
    value_format_name: percent_2
    description: "Conversion rate (Conversions / Clicks)"
    drill_fields: [detail*]
  }

  measure: cost_per_conversion {
    group_label: "Conversion Metrics"
    type: number
    sql: ${total_cost} / NULLIF(${total_conversions}, 0) ;;
    value_format_name: usd
    description: "Cost per conversion"
    drill_fields: [detail*]
  }

  measure: total_add_to_cart {
    group_label: "Other Conversion Totals"
    type: sum
    sql: ${all_conversions_add_to_cart} ;;
    description: "Total number of add-to-cart events"
    drill_fields: [detail*]
  }

  measure: total_checkouts {
    group_label: "Other Conversion Totals"
    type: sum
    sql: ${all_conversions_checkout} ;;
    description: "Total number of checkout events"
    drill_fields: [detail*]
  }

  measure: total_other_conversions {
    group_label: "Other Conversion Totals"
    type: sum
    sql: ${all_conversions_other_event} ;;
    description: "Total number of other conversion events"
    drill_fields: [detail*]
  }

  measure: total_web_visits {
    group_label: "Other Conversion Totals"
    type: sum
    sql: ${all_conversions_web_visits} ;;
    description: "Total number of web visit conversions"
    drill_fields: [detail*]
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
