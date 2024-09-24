view: sales {
  sql_table_name: `lda_base_data.sales` ;;

  # PARAMETERS
  parameter: date_granularity {
    group_label: "Date Controls"
    type: unquoted
    label: "Date Granularity"
    description: "Select the time granularity for date-based dimensions"
    allowed_value: { label: "Year" value: "year" }
    allowed_value: { label: "Month" value: "month" }
    allowed_value: { label: "Week" value: "week" }
  }

  # DIMENSIONS

  # Primary Key
  dimension: primary_key {
    primary_key: yes
    type: string
    sql: ${order_id} || '-' || ${line_item_id} ;;
    hidden: yes
  }

  # Order Information
  dimension: order_id {
    group_label: "Order Information"
    type: string
    sql: ${TABLE}.order_id ;;
    label: "Order ID"
    description: "Unique identifier for each order"
  }

  dimension: line_item_id {
    group_label: "Order Info"
    type: number
    sql: ${TABLE}.line_item_id ;;
    label: "Line Item ID"
    description: "Unique identifier for each line item within an order"
  }

  dimension: order_status {
    group_label: "Order Info"
    type: string
    sql: ${TABLE}.order_status ;;
    label: "Order Status"
    description: "Current status of the order (e.g., 'Pending', 'Shipped', 'Delivered')"
  }

  dimension: updated_at {
    group_label: "Order Info"
    type: string
    sql: ${TABLE}.updated_at ;;
    label: "Last Updated"
    description: "Timestamp of when the order was last updated"
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

  # Product Information
  dimension: product_id {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_id ;;
    label: "Product ID"
    description: "Unique identifier for the product"
  }

  dimension: product_name {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
    description: "Name of the product"
  }

  dimension: category_name {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.category_name ;;
    label: "Product Category"
    description: "Category of the product"
  }

  # Customer Information
  dimension: user_id {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.user_id ;;
    label: "User ID"
    description: "Unique identifier for the customer"
  }

  dimension: email {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.email ;;
    label: "Customer Email"
    description: "Email address of the customer"
  }

  dimension: first_name {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.first_name ;;
    label: "Customer First Name"
    description: "First name of the customer"
  }

  dimension: last_name {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.last_name ;;
    label: "Customer Last Name"
    description: "Last name of the customer"
  }

  dimension: location {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.location ;;
    label: "Customer Location"
    description: "Geographic location of the customer"
  }

  dimension: phone_number {
    group_label: "Customer Info"
    type: string
    sql: ${TABLE}.phone_number ;;
    label: "Customer Phone Number"
    description: "Contact phone number of the customer"
  }

  # Sales Information
  dimension: channel {
    group_label: "Sales Info"
    type: string
    sql: ${TABLE}.channel ;;
    label: "Sales Channel"
    description: "Channel through which the sale was made (e.g., 'Online', 'In-store')"
  }

  dimension: currency {
    group_label: "Sales Info"
    type: string
    sql: ${TABLE}.currency ;;
    label: "Currency"
    description: "Currency in which the sale was made"
  }

  # Pricing Information
  dimension: unit_price {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.unit_price ;;
    value_format_name: decimal_2
    label: "Unit Price"
    description: "Price per unit of the product"
  }

  dimension: discounts {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.discounts ;;
    value_format_name: decimal_2
    label: "Discount Amount"
    description: "Amount of discount applied to the sale"
  }

  dimension: total_value {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.total_value ;;
    value_format_name: decimal_2
    label: "Total Sale Value"
    description: "Total value of the sale including discounts, shipping, and tax"
  }

  dimension: gross_total_value {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.gross_total_value ;;
    label: "Gross Total Value"
    description: "Total value of the sale before discounts, shipping, and tax"
  }

  dimension: net_value {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.net_value ;;
    label: "Net Sale Value"
    description: "Net value of the sale after discounts, but before shipping and tax"
  }

  dimension: shipping {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.shipping ;;
    label: "Shipping Cost"
    description: "Cost of shipping for the order"
  }

  dimension: tax {
    group_label: "Pricing Info"
    type: number
    sql: ${TABLE}.tax ;;
    label: "Tax Amount"
    description: "Amount of tax applied to the sale"
  }

  dimension: units {
    group_label: "Sales Info"
    type: number
    sql: ${TABLE}.units ;;
    label: "Units Sold"
    description: "Number of units sold in this line item"
  }

  # DIMENSION GROUPS

  dimension_group: sale_datetime {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      day_of_month,
      hour_of_day
    ]
    convert_tz: no
    datatype: datetime
    sql: DATETIME(${TABLE}.datetime) ;;
    label: "Sale"
    description: "Timestamp of when the sale occurred"
  }

  # DYNAMIC FIELDS

  dimension: date {
    group_label: "Dates"
    sql:
      CASE
        WHEN {% parameter date_granularity %} = 'year' THEN ${sale_datetime_year}
        WHEN {% parameter date_granularity %} = 'month' THEN ${sale_datetime_month}
        WHEN {% parameter date_granularity %} = 'week' THEN ${sale_datetime_week}
        ELSE ${sale_datetime_date}
      END ;;
    label: "Sale Date (Dynamic)"
    description: "Sale date at the granularity specified by the Date Granularity parameter"
  }

  # MEASURES

  measure: total_sales {
    group_label: "Sales Metrics"
    type: sum
    sql: ${total_value} ;;
    value_format_name: decimal_2
    label: "Total Sales"
    description: "Sum of total sale values"
    drill_fields: [
      order_id,
      sale_datetime_date,
      product_name,
      category_name,
      organization_name,
      channel,
      total_value,
      units
    ]
  }

  measure: total_units_sold {
    group_label: "Sales Metrics"
    type: sum
    sql: ${units} ;;
    label: "Total Units Sold"
    description: "Sum of all units sold"
    drill_fields: [
      product_name,
      category_name,
      organization_name,
      channel,
      units
    ]
  }

  measure: average_order_value {
    group_label: "Sales Metrics"
    type: average
    sql: ${total_value} ;;
    value_format_name: decimal_2
    label: "Average Order Value"
    description: "Average value of orders"
    drill_fields: [
      order_id,
      sale_datetime_date,
      product_name,
      category_name,
      organization_name,
      channel,
      total_value
    ]
  }

  measure: total_discount_amount {
    group_label: "Sales Metrics"
    type: sum
    sql: ${discounts} ;;
    value_format_name: decimal_2
    label: "Total Discount Amount"
    description: "Sum of all discounts applied"
    drill_fields: [
      order_id,
      sale_datetime_date,
      product_name,
      category_name,
      organization_name,
      channel,
      discounts
    ]
  }

  measure: count_orders {
    group_label: "Sales Metrics"
    type: count_distinct
    sql: ${order_id} ;;
    label: "Number of Orders"
    description: "Count of unique orders"
    drill_fields: [
      order_id,
      sale_datetime_date,
      organization_name,
      channel,
      total_value
    ]
  }

  # SETS

  set: detail {
    fields: [
      order_id,
      product_name,
      category_name,
      user_id,
      channel,
      total_sales,
      total_units_sold
    ]
  }
}
