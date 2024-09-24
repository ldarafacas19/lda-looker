
view:mericas_generales_negocio_new_users_reteined_users_meta_spend_google_spend_revenue_per_segment {
  derived_table: {
    sql: WITH
        normalized_sales AS (
          SELECT
            user_id,
            organization_id,
            organization_name,
            total_value,
            discount_value,
            -- Extraer los primeros 10 caracteres para obtener la fecha en formato `YYYY-MM-DD`
            DATE(SUBSTR(datetime, 1, 10)) AS date
          FROM
            `linnda-tech.lda_base_data.sales`
        ),

        first_purchase AS (
          SELECT
            user_id,
            MIN(date) AS first_purchase_date
          FROM
            normalized_sales
          GROUP BY
            user_id
        ),

        sales_data AS (
          SELECT
            s.date,
            s.organization_id,
            MAX(s.organization_name) AS organization_name,
            SUM(s.total_value) AS total_sales,
            SUM(CASE WHEN s.date = f.first_purchase_date THEN 1 ELSE 0 END) AS total_new_users,
            SUM(CASE WHEN s.date = f.first_purchase_date THEN s.total_value ELSE 0 END) AS new_users_sales,
            SUM(CASE WHEN s.date != f.first_purchase_date THEN 1 ELSE 0 END) AS retained_users,
            SUM(CASE WHEN s.date != f.first_purchase_date THEN s.total_value ELSE 0 END) AS retained_users_sales,
            SUM(s.discount_value) AS total_discounts,
            AVG(s.total_value) AS AOV_general,
            AVG(CASE WHEN s.date = f.first_purchase_date THEN s.total_value ELSE NULL END) AS AOV_new_users,
            AVG(CASE WHEN s.date != f.first_purchase_date THEN s.total_value ELSE NULL END) AS AOV_retained_users
          FROM
            normalized_sales s
          LEFT JOIN
            first_purchase f ON s.user_id = f.user_id
          GROUP BY
            s.date,
            s.organization_id
        ),

        truncated_meta_ads AS (
          SELECT
            -- Extraer los primeros 10 caracteres para obtener la fecha en formato `YYYY-MM-DD`
            DATE(SUBSTR(date_start, 1, 10)) AS date,
            organization_id,
            MAX(organization_name) AS organization_name,
            SUM(spend) AS acquisition_facebook_spend
          FROM
            `linnda-tech.lda_base_data.meta_ads`
          GROUP BY
            date,
            organization_id
        ),

        truncated_google_ads AS (
          SELECT
            -- Extraer los primeros 10 caracteres para obtener la fecha en formato `YYYY-MM-DD`
            DATE(SUBSTR(date, 1, 10)) AS date,
            organization_id,
            MAX(organization_name) AS organization_name,
            SUM(cost) AS acquisition_google_spend
          FROM
            `linnda-tech.lda_base_data.google_ads`
          GROUP BY
            date,
            organization_id
        )

      SELECT
        sales.date,
        sales.organization_id,
        sales.organization_name,
        sales.total_sales,
        sales.total_discounts,
        sales.total_new_users,
        sales.retained_users,
        sales.new_users_sales,
        sales.retained_users_sales,
        sales.AOV_general,
        sales.AOV_new_users,
        sales.AOV_retained_users,
        meta.acquisition_facebook_spend,
        google.acquisition_google_spend,
        (meta.acquisition_facebook_spend + google.acquisition_google_spend) AS total_spend,
        CASE
          WHEN sales.total_new_users > 0 THEN
            (meta.acquisition_facebook_spend + google.acquisition_google_spend) / sales.total_new_users
          ELSE
            NULL
        END AS CAC_blended
      FROM
        sales_data sales
      JOIN
        truncated_meta_ads meta ON sales.date = meta.date AND sales.organization_id = meta.organization_id
      JOIN
        truncated_google_ads google ON sales.date = google.date AND sales.organization_id = google.organization_id
      ORDER BY
        sales.date ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  dimension: total_discounts {
    type: number
    sql: ${TABLE}.total_discounts ;;
  }

  dimension: total_new_users {
    type: number
    sql: ${TABLE}.total_new_users ;;
  }

  dimension: retained_users {
    type: number
    sql: ${TABLE}.retained_users ;;
  }

  dimension: new_users_sales {
    type: number
    sql: ${TABLE}.new_users_sales ;;
  }

  dimension: retained_users_sales {
    type: number
    sql: ${TABLE}.retained_users_sales ;;
  }

  dimension: aov_general {
    type: number
    sql: ${TABLE}.AOV_general ;;
  }

  dimension: aov_new_users {
    type: number
    sql: ${TABLE}.AOV_new_users ;;
  }

  dimension: aov_retained_users {
    type: number
    sql: ${TABLE}.AOV_retained_users ;;
  }

  dimension: acquisition_facebook_spend {
    type: number
    sql: ${TABLE}.acquisition_facebook_spend ;;
  }

  dimension: acquisition_google_spend {
    type: number
    sql: ${TABLE}.acquisition_google_spend ;;
  }

  dimension: total_spend {
    type: number
    sql: ${TABLE}.total_spend ;;
  }

  dimension: cac_blended {
    type: number
    sql: ${TABLE}.CAC_blended ;;
  }

  set: detail {
    fields: [
        date,
  organization_id,
  organization_name,
  total_sales,
  total_discounts,
  total_new_users,
  retained_users,
  new_users_sales,
  retained_users_sales,
  aov_general,
  aov_new_users,
  aov_retained_users,
  acquisition_facebook_spend,
  acquisition_google_spend,
  total_spend,
  cac_blended
    ]
  }
}
