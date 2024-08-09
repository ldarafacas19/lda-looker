view: rfm {
  sql_table_name: `lda_base_data.rfm` ;;

  dimension: user_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  # Customer Information
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${TABLE}.first_name, ' ', ${TABLE}.last_name) ;;
  }

  # RFM Metrics
  dimension: recency {
    type: number
    sql: ${TABLE}.recency ;;
    description: "Days since last purchase"
  }

  dimension: frequency {
    type: number
    sql: ${TABLE}.frequency ;;
    description: "Average days between purchases"
  }

  dimension: monetary {
    type: number
    sql: ${TABLE}.monetary ;;
    description: "Total customer spend"
    value_format_name: usd
  }

  dimension: rfm_score {
    type: number
    sql: ${TABLE}.rfm_Score ;;
  }

  # Segmentation
  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension: loyalty_index {
    type: string
    sql: ${TABLE}.loyalty_index ;;
  }

  dimension: loyalty_index_val {
    type: string
    sql: ${TABLE}.Li ;;
    description: "Loyalty index value"
  }

  dimension: customer_group {
    type: string
    sql: ${TABLE}.`group` ;;
  }

  # Customer Value Metrics
  dimension: average_order_value {
    type: number
    sql: ${TABLE}.AOV ;;
    value_format_name: usd
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: total_value {
    type: number
    sql: ${TABLE}.total_value ;;
    value_format_name: usd
  }

  # Time-based Dimensions
  dimension_group: first_purchase {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_min ;;
  }

  dimension_group: last_purchase {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_max ;;
  }

  dimension: customer_lifetime_days {
    type: number
    sql: ${TABLE}.total_days ;;
  }

  # Customer Type
  dimension: is_new_customer {
    type: yesno
    sql: ${TABLE}.new = 1 ;;
  }

  dimension: is_returning_customer {
    type: yesno
    sql: ${TABLE}.returning = 1 ;;
  }

  # Measures
  measure: count_customers {
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id, full_name, email, segment, total_value]
  }

  measure: average_customer_value {
    type: average
    sql: ${total_value} ;;
    value_format_name: usd
  }

  measure: total_customer_value {
    type: sum
    sql: ${total_value} ;;
    value_format_name: usd
  }

  measure: average_rfm_score {
    type: average
    sql: ${rfm_score} ;;
    value_format_name: decimal_2
  }

  set: customer_detail {
    fields: [
      user_id,
      full_name,
      email,
      segment,
      loyalty_index,
      recency,
      frequency,
      monetary,
      rfm_score,
      total_orders,
      total_value,
      first_purchase_date,
      last_purchase_date
    ]
  }
}
