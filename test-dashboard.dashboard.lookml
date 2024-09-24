---
- dashboard: test_dashboard
  title: Test Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: ''
  filters_location_top: false
  preferred_slug: CnANL586HdTTk6l9qenpzf
  elements:
  - title: Test Dashboard
    name: Test Dashboard
    model: lda_prueba
    explore: sales
    type: table
    fields: [sales.email, sales.count_orders, sales.total_sales]
    sorts: [sales.count_orders desc 0]
    limit: 500
    column_limit: 50
    listen:
      Email: sales.email
    row: 1
    col: 0
    width: 9
    height: 11
  - title: New Tile
    name: New Tile
    model: lda_prueba
    explore: sales
    type: looker_line
    fields: [sales.total_sales, sales.count_orders, sales.category_name]
    sorts: [sales.total_sales desc 0]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#800000"
    defaults_version: 1
    hidden_pivots: {}
    listen: {}
    row: 7
    col: 9
    width: 8
    height: 5
  - title: New Tile
    name: New Tile (2)
    model: lda_prueba
    explore: sales
    type: looker_bar
    fields: [sales.total_sales, sales.count_orders, sales.category_name]
    sorts: [sales.total_sales desc 0]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    show_null_points: true
    interpolation: linear
    hidden_pivots: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_labels: legend
    label_type: labPer
    listen:
      Email: sales.email
    row: 1
    col: 9
    width: 8
    height: 6
  - name: titulo
    type: text
    title_text: titulo
    subtitle_text: subtitulo
    body_text: |-
      # Hola

      holahola
    row: 12
    col: 0
    width: 17
    height: 6
  - type: button
    name: button_5
    rich_content_json: '{"text":"Ir a Linnda","description":"link a linnda","newTab":true,"alignment":"center","size":"medium","style":"FILLED","color":"#1A73E8","href":"https://linnda.co"}'
    row: 0
    col: 0
    width: 24
    height: 1
  filters:
  - name: Email
    title: Email
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options:
      - adrianarcohrs@hotmail.com
    model: lda_prueba
    explore: sales
    listens_to_filters: []
    field: sales.email
