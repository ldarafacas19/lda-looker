view: sales {
  sql_table_name: `lda_base_data.sales` ;;

  dimension: primary_key {
    primary_key: yes
    type: string
    sql: ${order_id} || '-' || ${line_item_id} ;;
    hidden: yes
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: line_item_id {
    type: number
    sql: ${TABLE}.line_item_id ;;
  }

  dimension_group: sale_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: sale_datetime {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: datetime
    sql: ${TABLE}.datetime ;;
  }

  # General Dimensions
  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  # Order dimensions
  dimension: order_status {
    type: string
    sql: ${TABLE}.order_status ;;
  }

  dimension: updated_at {
    type: string
    sql: ${TABLE}.updated_at ;;
  }

  # Product dimensions
  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
  }

  # Customer dimensions
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}.phone_number ;;
  }

  # Sales dimensions
  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  # Pricing dimensions
  dimension: unit_price {
    type: number
    sql: ${TABLE}.unit_price ;;
    value_format_name: decimal_2
  }

  dimension: discounts {
    type: number
    sql: ${TABLE}.discounts ;;
    value_format_name: decimal_2
  }

  dimension: total_value {
    type: number
    sql: ${TABLE}.total_value ;;
    value_format_name: decimal_2
  }

  dimension: gross_total_value {
    type: number
    sql: ${TABLE}.gross_total_value ;;
  }

  dimension: net_value {
    type: number
    sql: ${TABLE}.net_value ;;
  }

  dimension: shipping {
    type: number
    sql: ${TABLE}.shipping ;;
  }

  dimension: tax {
    type: number
    sql: ${TABLE}.tax ;;
  }

  dimension: units {
    type: number
    sql: ${TABLE}.units ;;
  }

  # Measures
  measure: total_sales {
    type: sum
    sql: ${total_value} ;;
    value_format_name: decimal_2
  }

  measure: total_units_sold {
    type: sum
    sql: ${units} ;;
  }

  measure: average_order_value {
    type: average
    sql: ${total_value} ;;
    value_format_name: decimal_2
  }

  measure: total_discount_amount {
    type: sum
    sql: ${discounts} ;;
    value_format_name: decimal_2
  }

  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  set: detail {
    fields: [
      order_id,
      # sale_date,
      product_name,
      category_name,
      user_id,
      channel,
      total_sales,
      total_units_sold
    ]
  }
}
