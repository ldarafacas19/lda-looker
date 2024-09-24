
view: incrementalidad {
  derived_table: {
    sql: WITH filtered_sales AS (
          SELECT
              s.user_id,
              s.email,
              s.total_value,
              CAST(CAST(s.date AS DATETIME) AS DATE) AS order_date,
              EXTRACT(YEAR FROM CAST(s.date AS DATETIME)) AS year,
              EXTRACT(MONTH FROM CAST(s.date AS DATETIME)) AS month,
              EXTRACT(DAY FROM CAST(s.date AS DATETIME)) AS day,
              s.organization_id,
              s.organization_name,
              s.order_status,
              r.total_orders,
              r.internal_id,
              r.group AS user_group
          FROM
              `linnda-tech.lda_base_data.sales` s
          LEFT JOIN
              `linnda-tech.lda_base_data.rfm` r ON s.user_id = r.user_id AND s.organization_id = r.organization_id
          WHERE
              s.order_status IN ('completed', 'processing', 'addi-approved', 'PAID', 'AUTHORIZED', 'PARTIALLY_REFUNDED', 'PARTIALLY_PAID', 'PENDING', 'SUCCESS', 'closed', 'open')
      ),

      first_order_dates AS (
          SELECT
              organization_id,
              user_id,
              MIN(order_date) AS first_order_date
          FROM filtered_sales
          GROUP BY organization_id, user_id
      ),

      categorized_orders AS (
          SELECT
              fs.*,
              CASE
                  WHEN fs.order_date = f.first_order_date THEN 'Acquisition'
                  ELSE 'Retention'
              END AS user_type
          FROM filtered_sales fs
          LEFT JOIN first_order_dates f
          ON fs.user_id = f.user_id AND fs.organization_id = f.organization_id
      ),

      daily_metrics AS (
          SELECT
              organization_id,
              organization_name,
              year,
              month,
              day,
              order_date,
              user_group,
              COUNT(DISTINCT CASE WHEN user_type = 'Acquisition' THEN user_id END) AS Adq_total_users,
              COUNT(DISTINCT CASE WHEN user_type = 'Retention' THEN user_id END) AS Ret_total_users,
              SUM(CASE WHEN user_type = 'Acquisition' THEN total_value END) AS Adq_total_sales,
              SUM(CASE WHEN user_type = 'Retention' THEN total_value END) AS Ret_total_sales,
              SUM(total_value) AS Total_sales
          FROM categorized_orders
          GROUP BY organization_id, organization_name, year, month, day, order_date, user_group
      ),

      unique_emails AS (
          SELECT
              fs.organization_name,
              fs.order_date,
              fs.email,
              fs.user_id,
              MIN(fs.order_date) OVER (PARTITION BY fs.organization_name, fs.email ORDER BY fs.order_date) AS first_purchase_date,
              fs.user_group
          FROM
              filtered_sales fs
          WHERE
              fs.organization_name IS NOT NULL
              AND fs.email IS NOT NULL
              AND fs.user_id IS NOT NULL
      ),

      daily_unique_emails AS (
          SELECT
              ue.organization_name,
              ue.order_date,
              ue.email,
              ue.first_purchase_date,
              ue.user_group
          FROM
              unique_emails ue
          WHERE
              ue.order_date = ue.first_purchase_date
      ),

      daily_counts AS (
          SELECT
              due.organization_name,
              due.order_date,
              due.user_group,
              COUNT(DISTINCT due.email) AS daily_new_users
          FROM
              daily_unique_emails due
          GROUP BY
              due.organization_name, due.order_date, due.user_group
      ),

      all_dates AS (
          SELECT
              DISTINCT organization_name,
              order_date,
              user_group
          FROM
              daily_counts,
              UNNEST(['group_control', 'group_test']) AS user_group
      ),

      filled_dates AS (
          SELECT
              ad.organization_name,
              ad.order_date,
              ad.user_group,
              COALESCE(dc.daily_new_users, 0) AS daily_new_users
          FROM
              all_dates ad
          LEFT JOIN
              daily_counts dc
          ON
              ad.organization_name = dc.organization_name
              AND ad.order_date = dc.order_date
              AND ad.user_group = dc.user_group
      ),

      final_data AS (
          SELECT
              fd.organization_name,
              fd.order_date,
              fd.user_group,
              fd.daily_new_users,
              SUM(fd.daily_new_users) OVER (PARTITION BY fd.organization_name, fd.user_group ORDER BY fd.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS usuarios_acumulados
          FROM
              filled_dates fd
      ),

      aggregated_data AS (
          SELECT
              co.organization_name,
              co.order_date,
              co.year,
              co.month,
              co.day,
              fd.user_group,
              fd.usuarios_acumulados,
              SUM(CASE WHEN co.user_type = 'Retention' AND fd.user_group = 'group_test' THEN co.total_value ELSE 0 END) AS Ret_total_sales_test,
              SUM(CASE WHEN co.user_type = 'Retention' AND fd.user_group = 'group_control' THEN co.total_value ELSE 0 END) AS Ret_total_sales_control,
              COUNT(DISTINCT CASE WHEN co.user_type = 'Retention' AND fd.user_group = 'group_test' THEN co.user_id ELSE NULL END) AS Ret_total_users_test,
              COUNT(DISTINCT CASE WHEN co.user_type = 'Retention' AND fd.user_group = 'group_control' THEN co.user_id ELSE NULL END) AS Ret_total_users_control
          FROM
              categorized_orders co
          JOIN
              final_data fd ON co.organization_name = fd.organization_name
              AND co.order_date = fd.order_date
              AND co.user_group = fd.user_group
          GROUP BY
              co.organization_name, co.order_date, co.year, co.month, co.day, fd.user_group, fd.usuarios_acumulados
      ),

      reference_counts AS (
          SELECT
              organization_name,
              COUNT(DISTINCT CASE WHEN `group` = 'group_test' THEN user_id END) AS usuarios_test,
              COUNT(DISTINCT CASE WHEN `group` = 'group_control' OR `group` IS NULL THEN user_id END) AS usuarios_control
          FROM
              `linnda-tech.lda_base_data.rfm`
          GROUP BY
              organization_name
      ),

      aggregated_final AS (
          SELECT
              organization_name,
              order_date,
              year,
              month,
              day,
              user_group,
              usuarios_acumulados,
              LAST_VALUE(usuarios_acumulados IGNORE NULLS) OVER (PARTITION BY organization_name, user_group ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS usuarios_acumulados_corrected,
              Ret_total_sales_test,
              Ret_total_sales_control,
              Ret_total_users_test,
              Ret_total_users_control
          FROM
              aggregated_data
      ),

      grouped_final AS (
          SELECT
              af.organization_name,
              af.order_date,
              af.year,
              af.month,
              af.day,
              SUM(CASE WHEN af.user_group = 'group_test' THEN af.usuarios_acumulados_corrected ELSE 0 END) AS usuarios_acumulados_test,
              SUM(CASE WHEN af.user_group = 'group_control' THEN af.usuarios_acumulados_corrected ELSE 0 END) AS usuarios_acumulados_control,
              SUM(af.Ret_total_users_test) AS Ret_total_users_test,
              SUM(af.Ret_total_users_control) AS Ret_total_users_control,
              SUM(af.Ret_total_sales_test) AS Ret_total_sales_test,
              SUM(af.Ret_total_sales_control) AS Ret_total_sales_control
          FROM
              aggregated_final af
          GROUP BY
              af.organization_name, af.order_date, af.year, af.month, af.day
      )

      SELECT
          gf.organization_name,
          gf.order_date,
          gf.year,
          gf.month,
          gf.day,
          gf.usuarios_acumulados_test,
          gf.usuarios_acumulados_control,
          gf.Ret_total_users_test,
          gf.Ret_total_users_control,
          gf.Ret_total_sales_test,
          gf.Ret_total_sales_control,
          ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) AS conversion_test,
          ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4) AS conversion_control,
          ROUND(
              CASE
                  WHEN ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                       ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4) > 0 THEN
                      ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                      ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4)
                  ELSE 0
              END, 4) AS incrementalidad,
          ROUND(
              gf.usuarios_acumulados_test *
              CASE
                  WHEN ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                       ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4) > 0 THEN
                      ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                      ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4)
                  ELSE 0
              END, 4) AS usuarios_incrementales,
          ROUND(
              gf.usuarios_acumulados_test *
              CASE
                  WHEN ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                       ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4) > 0 THEN
                      ROUND(CASE WHEN gf.usuarios_acumulados_test != 0 THEN gf.Ret_total_users_test * 1.0 / gf.usuarios_acumulados_test ELSE 0 END, 4) -
                      ROUND(CASE WHEN gf.usuarios_acumulados_control != 0 THEN gf.Ret_total_users_control * 1.0 / gf.usuarios_acumulados_control ELSE 0 END, 4)
                  ELSE 0
              END * (gf.Ret_total_sales_test * 1.0 / CASE WHEN gf.Ret_total_users_test != 0 THEN gf.Ret_total_users_test ELSE 1 END), 4) AS ventas_incrementales
      FROM
          grouped_final gf
      ORDER BY
          gf.organization_name, gf.order_date ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}.day ;;
  }

  dimension: usuarios_acumulados_test {
    type: number
    sql: ${TABLE}.usuarios_acumulados_test ;;
  }

  dimension: usuarios_acumulados_control {
    type: number
    sql: ${TABLE}.usuarios_acumulados_control ;;
  }

  dimension: ret_total_users_test {
    type: number
    sql: ${TABLE}.Ret_total_users_test ;;
  }

  dimension: ret_total_users_control {
    type: number
    sql: ${TABLE}.Ret_total_users_control ;;
  }

  dimension: ret_total_sales_test {
    type: number
    sql: ${TABLE}.Ret_total_sales_test ;;
  }

  dimension: ret_total_sales_control {
    type: number
    sql: ${TABLE}.Ret_total_sales_control ;;
  }

  dimension: conversion_test {
    type: number
    sql: ${TABLE}.conversion_test ;;
  }

  dimension: conversion_control {
    type: number
    sql: ${TABLE}.conversion_control ;;
  }

  dimension: incrementalidad {
    type: number
    sql: ${TABLE}.incrementalidad ;;
  }

  dimension: usuarios_incrementales {
    type: number
    sql: ${TABLE}.usuarios_incrementales ;;
  }

  dimension: ventas_incrementales {
    type: number
    sql: ${TABLE}.ventas_incrementales ;;
  }

  set: detail {
    fields: [
        organization_name,
  order_date,
  year,
  month,
  day,
  usuarios_acumulados_test,
  usuarios_acumulados_control,
  ret_total_users_test,
  ret_total_users_control,
  ret_total_sales_test,
  ret_total_sales_control,
  conversion_test,
  conversion_control,
  incrementalidad,
  usuarios_incrementales,
  ventas_incrementales
    ]
  }
}
