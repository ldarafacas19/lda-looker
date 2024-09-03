view: meta_ads {
  sql_table_name: `lda_base_data.meta_ads` ;;

  # DIMENSIONS

  # Primary Key
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.date_start, '-', ${TABLE}.ad_id) ;;
    description: "Unique identifier for each ad performance record"
  }

  # Ad Information
  dimension: ad_id {
    group_label: "Ad Info"
    type: number
    sql: ${TABLE}.ad_id ;;
    label: "Ad ID"
    description: "Unique identifier for the ad"
  }

  dimension: ad_name {
    group_label: "Ad Info"
    type: string
    sql: ${TABLE}.ad_name ;;
    label: "Ad Name"
    description: "Name of the ad"
  }

  dimension: ad_status {
    group_label: "Ad Info"
    type: string
    sql: ${TABLE}.ad_status ;;
    label: "Ad Status"
    description: "Current status of the ad (e.g., active, paused)"
  }

  dimension: ad_deep_link {
    group_label: "Ad Info"
    type: string
    sql: ${TABLE}.ad_deep_link ;;
    label: "Ad Deep Link"
    description: "Deep link associated with the ad"
  }

  dimension: body {
    group_label: "Ad Content"
    type: string
    sql: ${TABLE}.body ;;
    label: "Ad Body"
    description: "Main text content of the ad"
  }

  dimension: title {
    group_label: "Ad Content"
    type: string
    sql: ${TABLE}.title ;;
    label: "Ad Title"
    description: "Title of the ad"
  }

  dimension: image_url {
    group_label: "Ad Content"
    type: string
    sql: ${TABLE}.image_url ;;
    label: "Image URL"
    description: "URL of the image used in the ad"
  }

  dimension: call_to_action_type {
    group_label: "Ad Content"
    type: string
    sql: ${TABLE}.call_to_action_type ;;
    label: "Call to Action Type"
    description: "Type of call-to-action used in the ad"
  }

  # Campaign Structure
  dimension: campaign_id {
    group_label: "Campaign Structure"
    type: number
    sql: ${TABLE}.campaign_id ;;
    label: "Campaign ID"
    description: "Unique identifier for the campaign"
  }

  dimension: campaign_name {
    group_label: "Campaign Structure"
    type: string
    sql: ${TABLE}.campaign_name ;;
    label: "Campaign Name"
    description: "Name of the campaign"
  }

  dimension: adset_id {
    group_label: "Campaign Structure"
    type: number
    sql: ${TABLE}.adset_id ;;
    label: "Ad Set ID"
    description: "Unique identifier for the ad set"
  }

  dimension: adset_name {
    group_label: "Campaign Structure"
    type: string
    sql: ${TABLE}.adset_name ;;
    label: "Ad Set Name"
    description: "Name of the ad set"
  }

  # Account Information
  dimension: account_id {
    group_label: "Account Info"
    type: number
    sql: ${TABLE}.account_id ;;
    label: "Account ID"
    description: "Unique identifier for the ad account"
  }

  dimension: account_name {
    group_label: "Account Info"
    type: string
    sql: ${TABLE}.account_name ;;
    label: "Account Name"
    description: "Name of the ad account"
  }

  dimension: account_currency {
    group_label: "Account Info"
    type: string
    sql: ${TABLE}.account_currency ;;
    label: "Account Currency"
    description: "Currency used for the ad account"
  }

  # Date Dimensions
  dimension_group: ad_date {
    type: time
    timeframes: [date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_start ;;
    label: "Ad Performance"
    description: "Date of the ad performance data"
  }

  # Performance Metrics
  dimension: impressions {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.impressions ;;
    label: "Impressions"
    description: "Number of times the ad was shown"
  }

  dimension: clicks {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.clicks ;;
    label: "Clicks"
    description: "Number of clicks on the ad"
  }

  dimension: spend {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.spend ;;
    value_format_name: usd
    label: "Spend"
    description: "Amount spent on the ad"
  }

  dimension: reach {
    group_label: "Performance Metrics"
    type: number
    sql: ${TABLE}.reach ;;
    label: "Reach"
    description: "Number of unique users who saw the ad"
  }

  # Calculated Dimensions
  dimension: ctr {
    group_label: "Calculated Metrics"
    type: number
    sql: ${TABLE}.ctr ;;
    value_format_name: percent_2
    label: "CTR"
    description: "Click-through rate (Clicks / Impressions)"
  }

  dimension: cpc {
    group_label: "Calculated Metrics"
    type: number
    sql: ${TABLE}.cpc ;;
    value_format_name: usd
    label: "CPC"
    description: "Cost per click (Spend / Clicks)"
  }

  dimension: cpm {
    group_label: "Calculated Metrics"
    type: number
    sql: ${TABLE}.cpm ;;
    value_format_name: usd
    label: "CPM"
    description: "Cost per thousand impressions (Spend / Impressions * 1000)"
  }

  # Conversion Metrics
  dimension: purchase {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.purchase ;;
    label: "Purchases"
    description: "Number of purchases attributed to the ad"
  }

  dimension: purchase_value {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.purchase_value ;;
    value_format_name: usd
    label: "Purchase Value"
    description: "Total value of purchases attributed to the ad"
  }

  dimension: roas {
    group_label: "Conversion Metrics"
    type: number
    sql: ${TABLE}.ROAS ;;
    value_format_name: decimal_2
    label: "ROAS"
    description: "Return on Ad Spend (Purchase Value / Spend)"
  }

  # MEASURES
  measure: total_impressions {
    group_label: "Performance Totals"
    type: sum
    sql: ${impressions} ;;
    label: "Total Impressions"
    description: "Sum of all impressions"
    drill_fields: [detail*]
  }

  measure: total_clicks {
    group_label: "Performance Totals"
    type: sum
    sql: ${clicks} ;;
    label: "Total Clicks"
    description: "Sum of all clicks"
    drill_fields: [detail*]
  }

  measure: total_spend {
    group_label: "Performance Totals"
    type: sum
    sql: ${spend} ;;
    value_format_name: usd
    label: "Total Spend"
    description: "Sum of all ad spend"
    drill_fields: [detail*]
  }

  measure: total_reach {
    group_label: "Performance Totals"
    type: sum
    sql: ${reach} ;;
    label: "Total Reach"
    description: "Sum of all unique users reached"
    drill_fields: [detail*]
  }

  measure: total_purchases {
    group_label: "Conversion Totals"
    type: sum
    sql: ${purchase} ;;
    label: "Total Purchases"
    description: "Sum of all purchases"
    drill_fields: [detail*]
  }

  measure: total_purchase_value {
    group_label: "Conversion Totals"
    type: sum
    sql: ${purchase_value} ;;
    value_format_name: usd
    label: "Total Purchase Value"
    description: "Sum of all purchase values"
    drill_fields: [detail*]
  }

  measure: average_ctr {
    group_label: "Performance Averages"
    type: average
    sql: ${ctr} ;;
    value_format_name: percent_2
    label: "Average CTR"
    description: "Average click-through rate across all ads"
    drill_fields: [detail*]
  }

  measure: average_cpc {
    group_label: "Performance Averages"
    type: average
    sql: ${cpc} ;;
    value_format_name: usd
    label: "Average CPC"
    description: "Average cost per click across all ads"
    drill_fields: [detail*]
  }

  measure: average_cpm {
    group_label: "Performance Averages"
    type: average
    sql: ${cpm} ;;
    value_format_name: usd
    label: "Average CPM"
    description: "Average cost per thousand impressions across all ads"
    drill_fields: [detail*]
  }

  measure: overall_roas {
    group_label: "Conversion Metrics"
    type: number
    sql: ${total_purchase_value} / NULLIF(${total_spend}, 0) ;;
    value_format_name: decimal_2
    label: "Overall ROAS"
    description: "Return on Ad Spend across all ads (Total Purchase Value / Total Spend)"
    drill_fields: [detail*]
  }

  # SETS
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
