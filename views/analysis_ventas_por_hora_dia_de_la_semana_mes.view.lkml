view: analysis_ventas_por_hora_dia_de_la_semana_mes {
  derived_table: {
    sql: WITH filtered_sales AS (
          SELECT
              s.order_id,
              s.user_id,
              s.email,
              s.total_value,
              SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', s.datetime) AS datetime,
              EXTRACT(YEAR FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', s.datetime)) AS year,
              EXTRACT(MONTH FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', s.datetime)) AS month,
              EXTRACT(DAY FROM SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', s.datetime)) AS day,
              s.organization_id,
              s.organization_name,
              s.channel AS canal_de_venta,
              s.order_status,
              r.internal_id,
              r.loyalty_index,
              r.total_orders
          FROM
              `linnda-tech.lda_base_data.sales` s
          LEFT JOIN
              `linnda-tech.lda_base_data.rfm` r ON s.user_id = r.user_id AND s.organization_id = r.organization_id
          WHERE
              s.order_status IN ('completed', 'processing', 'addi-approved', 'PAID', 'AUTHORIZED', 'PARTIALLY_REFUNDED', 'PARTIALLY_PAID', 'PENDING', 'SUCCESS', 'closed', 'open')
              AND s.organization_name IS NOT NULL
              AND s.channel IS NOT NULL
      ),

      first_order_dates AS (
          SELECT
              organization_id,
              user_id,
              MIN(CAST(datetime AS DATE)) AS first_order_date
          FROM filtered_sales
          GROUP BY organization_id, user_id
      ),

      categorized_orders AS (
          SELECT
              fs.*,
              CASE
                  WHEN CAST(fs.datetime AS DATE) = f.first_order_date THEN 'Usuario nuevo'
                  ELSE 'Usuario retenido'
              END AS user_type
          FROM filtered_sales fs
          LEFT JOIN first_order_dates f
          ON fs.user_id = f.user_id AND fs.organization_id = f.organization_id
      )

      SELECT
          organization_name,
          canal_de_venta,
          CASE
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 1 THEN 'Domingo'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 2 THEN 'Lunes'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 3 THEN 'Martes'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 4 THEN 'Miércoles'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 5 THEN 'Jueves'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 6 THEN 'Viernes'
              WHEN EXTRACT(DAYOFWEEK FROM datetime) = 7 THEN 'Sábado'
              ELSE 'Día desconocido'
          END AS dia,
          CASE
              WHEN EXTRACT(MONTH FROM datetime) = 1 THEN 'Enero'
              WHEN EXTRACT(MONTH FROM datetime) = 2 THEN 'Febrero'
              WHEN EXTRACT(MONTH FROM datetime) = 3 THEN 'Marzo'
              WHEN EXTRACT(MONTH FROM datetime) = 4 THEN 'Abril'
              WHEN EXTRACT(MONTH FROM datetime) = 5 THEN 'Mayo'
              WHEN EXTRACT(MONTH FROM datetime) = 6 THEN 'Junio'
              WHEN EXTRACT(MONTH FROM datetime) = 7 THEN 'Julio'
              WHEN EXTRACT(MONTH FROM datetime) = 8 THEN 'Agosto'
              WHEN EXTRACT(MONTH FROM datetime) = 9 THEN 'Septiembre'
              WHEN EXTRACT(MONTH FROM datetime) = 10 THEN 'Octubre'
              WHEN EXTRACT(MONTH FROM datetime) = 11 THEN 'Noviembre'
              WHEN EXTRACT(MONTH FROM datetime) = 12 THEN 'Diciembre'
              ELSE 'Mes desconocido'
          END AS mes,
          COALESCE(EXTRACT(YEAR FROM datetime), 0) AS year, -- Garantiza que year no sea nulo
          COALESCE(EXTRACT(HOUR FROM datetime), 0) AS hora,
          user_type,
          COUNT(DISTINCT order_id) AS ordenes
      FROM
          categorized_orders
      GROUP BY
          organization_name, canal_de_venta, dia, mes, year, hora, user_type
      ORDER BY
          organization_name, canal_de_venta, year, mes, dia, hora, user_type ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: canal_de_venta {
    type: string
    sql: ${TABLE}.canal_de_venta ;;
  }

  dimension: dia {
    type: string
    sql: ${TABLE}.dia ;;
  }

  dimension: mes {
    type: string
    sql: ${TABLE}.mes ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: hora {
    type: number
    sql: ${TABLE}.hora ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}.user_type ;;
  }

  dimension: ordenes {
    type: number
    sql: ${TABLE}.ordenes ;;
  }

  set: detail {
    fields: [
      organization_name,
      canal_de_venta,
      dia,
      mes,
      year,
      hora,
      user_type,
      ordenes
    ]
  }
}
