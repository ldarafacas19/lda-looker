
view: reporteria_forecast {
  derived_table: {
    sql: WITH filtered_orders AS (
        SELECT
          user_id,
          order_id,
          DATE(date) AS order_date,
          EXTRACT(YEAR FROM DATE(date)) AS year,
          EXTRACT(MONTH FROM DATE(date)) AS month,
          EXTRACT(WEEK FROM DATE(date)) AS week,
          EXTRACT(DAY FROM DATE(date)) AS day,
          ROUND(total_value) AS total_value,
          organization_id,
          organization_name,
          order_status
        FROM `linnda-tech.lda_base_data.sales`
        WHERE order_status IN ('completed', 'processing', 'addi-approved', 'PAID', 'AUTHORIZED', 'PARTIALLY_REFUNDED', 'PARTIALLY_PAID', 'PENDING', 'SUCCESS', 'closed', 'open')
      ),
      first_order_dates AS (
        SELECT
          organization_id,
          user_id,
          MIN(order_date) AS first_order_date
        FROM filtered_orders
        GROUP BY organization_id, user_id
      ),
      categorized_orders AS (
        SELECT
          fo.*,
          CASE
            WHEN fo.order_date = f.first_order_date THEN 'Acquisition'
            ELSE 'Retention'
          END AS user_type
        FROM filtered_orders fo
        LEFT JOIN first_order_dates f
        ON fo.user_id = f.user_id and fo.organization_id = f.organization_id
      ),
      daily_metrics AS (
        SELECT
          organization_id,
          organization_name,
          order_date,
          year,
          month,
          week,
          day,
          COUNT(DISTINCT CASE WHEN user_type = 'Acquisition' THEN user_id END) AS Usuarios_adquisicion,
          COUNT(DISTINCT CASE WHEN user_type = 'Retention' THEN user_id END) AS Usuarios_retencion,
          COUNT(CASE WHEN user_type = 'Acquisition' THEN order_id END) AS Ordenes_adquisicion,
          COUNT(CASE WHEN user_type = 'Retention' THEN order_id END) AS Ordenes_retencion,
          ROUND(SUM(CASE WHEN user_type = 'Acquisition' THEN total_value END)) AS Ventas_adquisicion,
          ROUND(SUM(CASE WHEN user_type = 'Retention' THEN total_value END)) AS Ventas_retencion,
          ROUND(SUM(total_value)) AS Ventas_totales
        FROM categorized_orders
        GROUP BY organization_id, organization_name, year, month, week, day, order_date
      ),
      last_7_days_metrics AS (
        SELECT
          organization_id,
          organization_name,
          ROUND(AVG(Ventas_adquisicion)) AS Promedio_diario_adquisicion,
          ROUND(AVG(Ventas_retencion)) AS Promedio_diario_retencion,
          ROUND(AVG(Ventas_totales)) AS Promedio_diario_totales
        FROM daily_metrics
        WHERE order_date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND CURRENT_DATE()
        GROUP BY organization_id, organization_name
      ),
      total_sales_up_to_now AS (
        SELECT
          organization_id,
          organization_name,
          ROUND(SUM(Ventas_adquisicion)) AS Total_ventas_adquisicion,
          ROUND(SUM(Ventas_retencion)) AS Total_ventas_retencion,
          ROUND(SUM(Ventas_totales)) AS Total_ventas_totales
        FROM daily_metrics
        WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE())
          AND EXTRACT(MONTH FROM order_date) = EXTRACT(MONTH FROM CURRENT_DATE())
        GROUP BY organization_id, organization_name
      ),
      forecast_metrics AS (
        SELECT
          l7.organization_id,
          l7.organization_name,
          l7.Promedio_diario_adquisicion,
          l7.Promedio_diario_retencion,
          l7.Promedio_diario_totales,
          ROUND((l7.Promedio_diario_adquisicion * (EXTRACT(DAY FROM LAST_DAY(CURRENT_DATE())) - EXTRACT(DAY FROM CURRENT_DATE()))) + ts.Total_ventas_adquisicion) AS Forecast_ventas_adquisicion,
          ROUND((l7.Promedio_diario_retencion * (EXTRACT(DAY FROM LAST_DAY(CURRENT_DATE())) - EXTRACT(DAY FROM CURRENT_DATE()))) + ts.Total_ventas_retencion) AS Forecast_ventas_retencion,
          ROUND((l7.Promedio_diario_totales * (EXTRACT(DAY FROM LAST_DAY(CURRENT_DATE())) - EXTRACT(DAY FROM CURRENT_DATE()))) + ts.Total_ventas_totales) AS Forecast_ventas_totales
        FROM last_7_days_metrics l7
        JOIN total_sales_up_to_now ts
        ON l7.organization_id = ts.organization_id
          AND l7.organization_name = ts.organization_name
      ),
      max_order_date AS (
        SELECT
          organization_name,
          MAX(order_date) AS max_order_date
        FROM filtered_orders
        GROUP BY organization_name
      )
      SELECT
        dm.organization_id,
        dm.organization_name,
        dm.order_date,
        dm.year,
        dm.month,
        dm.week,
        dm.day,
        ROUND(dm.Usuarios_adquisicion) AS Usuarios_adquisicion,
        ROUND(dm.Usuarios_retencion) AS Usuarios_retencion,
        ROUND(dm.Ordenes_adquisicion) AS Ordenes_adquisicion,
        ROUND(dm.Ordenes_retencion) AS Ordenes_retencion,
        ROUND(dm.Ventas_adquisicion) AS Ventas_adquisicion,
        ROUND(dm.Ventas_retencion) AS Ventas_retencion,
        ROUND(dm.Ventas_totales) AS Ventas_totales,
        ROUND(fm.Promedio_diario_adquisicion) AS Promedio_diario_adquisicion,
        ROUND(fm.Promedio_diario_retencion) AS Promedio_diario_retencion,
        ROUND(fm.Promedio_diario_totales) AS Promedio_diario_totales,
        ROUND(fm.Forecast_ventas_adquisicion) AS Forecast_ventas_adquisicion,
        ROUND(fm.Forecast_ventas_retencion) AS Forecast_ventas_retencion,
        ROUND(fm.Forecast_ventas_totales) AS Forecast_ventas_totales,
        max_od.max_order_date
      FROM daily_metrics dm
      LEFT JOIN forecast_metrics fm
      ON dm.organization_id = fm.organization_id
         AND dm.organization_name = fm.organization_name
      LEFT JOIN max_order_date max_od
      ON dm.organization_name = max_od.organization_name
      ORDER BY dm.organization_id, dm.organization_name, dm.year, dm.month, dm.week, dm.day ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_ventas_adquisicion {
    type: sum
    sql: ${ventas_adquisicion} ;;
  }

  measure: sum_ventas_retencion {
    type: sum
    sql: ${ventas_retencion} ;;
  }

  measure: sum_ventas_totales {
    type: sum
    sql: ${ventas_totales} ;;
  }

  measure: sum_forecast_ventas_adquisicion {
    type: sum
    sql: ${forecast_ventas_adquisicion} ;;
  }

  measure: sum_forecast_ventas_retencion {
    type: sum
    sql: ${forecast_ventas_retencion} ;;
  }

  measure: sum_forecast_ventas_totales {
    type: sum
    sql: ${forecast_ventas_totales} ;;
  }

  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
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

  dimension: week {
    type: number
    sql: ${TABLE}.week ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}.day ;;
  }

  dimension: usuarios_adquisicion {
    type: number
    sql: ${TABLE}.Usuarios_adquisicion ;;
  }

  dimension: usuarios_retencion {
    type: number
    sql: ${TABLE}.Usuarios_retencion ;;
  }

  dimension: ordenes_adquisicion {
    type: number
    sql: ${TABLE}.Ordenes_adquisicion ;;
  }

  dimension: ordenes_retencion {
    type: number
    sql: ${TABLE}.Ordenes_retencion ;;
  }

  dimension: ventas_adquisicion {
    type: number
    sql: ${TABLE}.Ventas_adquisicion ;;
  }

  dimension: ventas_retencion {
    type: number
    sql: ${TABLE}.Ventas_retencion ;;
  }

  dimension: ventas_totales {
    type: number
    sql: ${TABLE}.Ventas_totales ;;
  }

  dimension: promedio_diario_adquisicion {
    type: number
    sql: ${TABLE}.Promedio_diario_adquisicion ;;
  }

  dimension: promedio_diario_retencion {
    type: number
    sql: ${TABLE}.Promedio_diario_retencion ;;
  }

  dimension: promedio_diario_totales {
    type: number
    sql: ${TABLE}.Promedio_diario_totales ;;
  }

  dimension: forecast_ventas_adquisicion {
    type: number
    sql: ${TABLE}.Forecast_ventas_adquisicion ;;
  }

  dimension: forecast_ventas_retencion {
    type: number
    sql: ${TABLE}.Forecast_ventas_retencion ;;
  }

  dimension: forecast_ventas_totales {
    type: number
    sql: ${TABLE}.Forecast_ventas_totales ;;
  }

  dimension: max_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.max_order_date ;;
  }

  set: detail {
    fields: [
        organization_id,
  organization_name,
  order_date,
  year,
  month,
  week,
  day,
  usuarios_adquisicion,
  usuarios_retencion,
  ordenes_adquisicion,
  ordenes_retencion,
  ventas_adquisicion,
  ventas_retencion,
  ventas_totales,
  promedio_diario_adquisicion,
  promedio_diario_retencion,
  promedio_diario_totales,
  forecast_ventas_adquisicion,
  forecast_ventas_retencion,
  forecast_ventas_totales,
  max_order_date
    ]
  }
}
