view: rfm {
  sql_table_name: `lda_base_data.rfm` ;;

  # DIMENSIONS

  # Primary Key
  dimension: user_id {
    primary_key: yes
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.user_id ;;
    label: "User ID"
    description: "Unique identifier for each customer"
  }

# Organization Information
  dimension: organization_id {
    group_label: "Organization Info"
    type: string
    sql: ${TABLE}.organization_id ;;
    label: "Organization ID"
    description: "Unique identifier for the organization"
  }

  dimension: organization_name {
    group_label: "Organization Info"
    type: string
    sql: ${TABLE}.organization_name ;;
    label: "Organization Name"
    description: "Name of the organization"
  }

  # Customer Information
  dimension: email {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.email ;;
    label: "Customer Email"
    description: "Email address of the customer"
  }

  dimension: full_name {
    group_label: "Customer Info"
    type: string
    sql: CONCAT(${TABLE}.first_name, ' ', ${TABLE}.last_name) ;;
    label: "Customer Full Name"
    description: "Full name of the customer"
  }

  # RFM Metrics
  dimension: recency {
    group_label: "RFM Metrics"
    type: number
    sql: ${TABLE}.recency ;;
    label: "Recency"
    description: "Days since last purchase"
  }

  dimension: frequency {
    group_label: "RFM Metrics"
    type: number
    sql: ${TABLE}.frequency ;;
    label: "Frequency"
    description: "Average days between purchases"
  }

  dimension: monetary {
    group_label: "RFM Metrics"
    type: number
    sql: ${TABLE}.monetary ;;
    label: "Monetary Value"
    description: "Total customer spend"
    value_format_name: usd
  }

  dimension: rfm_score {
    group_label: "RFM Metrics"
    type: number
    sql: ${TABLE}.rfm_Score ;;
    label: "RFM Score"
    description: "Combined score based on Recency, Frequency, and Monetary value"
  }

  # Segmentation
  dimension: segment {
    group_label: "Customer Segmentation"
    type: string
    sql: ${TABLE}.segment ;;
    label: "Customer Segment"
    description: "Customer segment based on RFM analysis"
  }

  dimension: loyalty_index {
    group_label: "Customer Segmentation"
    type: string
    sql: ${TABLE}.loyalty_index ;;
    label: "Loyalty Index"
    description: "Customer loyalty classification"
  }

  dimension: loyalty_index_val {
    group_label: "Customer Segmentation"
    type: string
    sql: ${TABLE}.Li ;;
    label: "Loyalty Index Value"
    description: "Numeric value of the loyalty index"
  }

  dimension: customer_group {
    group_label: "Customer Segmentation"
    type: string
    sql: ${TABLE}.`group` ;;
    label: "Customer Group"
    description: "Grouping of customers based on their characteristics"
  }

  # Customer Value Metrics
  dimension: average_order_value {
    group_label: "Customer Value"
    type: number
    sql: ${TABLE}.AOV ;;
    label: "Average Order Value"
    description: "Average value of orders for this customer"
    value_format_name: usd
  }

  dimension: total_orders {
    group_label: "Customer Value"
    type: number
    sql: ${TABLE}.total_orders ;;
    label: "Total Orders"
    description: "Total number of orders made by this customer"
  }

  dimension: total_value {
    group_label: "Customer Value"
    type: number
    sql: ${TABLE}.total_value ;;
    label: "Total Customer Value"
    description: "Total monetary value of all orders made by this customer"
    value_format_name: usd
  }

  # Time-based Dimensions
  dimension_group: first_purchase {
    group_label: "Customer Timeline"
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_min ;;
    label: "First Purchase"
    description: "Date of the customer's first purchase"
  }

  dimension_group: last_purchase {
    group_label: "Customer Timeline"
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_max ;;
    label: "Last Purchase"
    description: "Date of the customer's most recent purchase"
  }

  dimension: customer_lifetime_days {
    group_label: "Customer Timeline"
    type: number
    sql: ${TABLE}.total_days ;;
    label: "Customer Lifetime (Days)"
    description: "Number of days between the customer's first and last purchase"
  }

  # Customer Type
  dimension: is_new_customer {
    group_label: "Customer Type"
    type: yesno
    sql: ${TABLE}.new = 1 ;;
    label: "Is New Customer"
    description: "Indicates if the customer is considered new"
  }

  dimension: is_returning_customer {
    group_label: "Customer Type"
    type: yesno
    sql: ${TABLE}.returning = 1 ;;
    label: "Is Returning Customer"
    description: "Indicates if the customer is a returning customer"
  }

  # MEASURES
  measure: count_customers {
    group_label: "Customer Metrics"
    type: count_distinct
    sql: ${user_id} ;;
    label: "Total Customers"
    description: "Count of unique customers"
    drill_fields: [customer_detail*]
  }

  measure: average_customer_value {
    group_label: "Customer Metrics"
    type: average
    sql: ${total_value} ;;
    label: "Average Customer Value"
    description: "Average total value across all customers"
    value_format_name: usd
    drill_fields: [customer_detail*]
  }

  measure: total_customer_value {
    group_label: "Customer Metrics"
    type: sum
    sql: ${total_value} ;;
    label: "Total Customer Value"
    description: "Sum of total value across all customers"
    value_format_name: usd
    drill_fields: [customer_detail*]
  }

  measure: average_rfm_score {
    group_label: "RFM Metrics"
    type: average
    sql: ${rfm_score} ;;
    label: "Average RFM Score"
    description: "Average RFM score across all customers"
    value_format_name: decimal_2
    drill_fields: [customer_detail*]
  }

  # SETS
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
