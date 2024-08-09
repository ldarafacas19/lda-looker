connection: "linnda_bq"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: lda_prueba_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: lda_prueba_default_datagroup

explore: sales {
  join: rfm {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sales.user_id} = ${rfm.user_id} OR ${sales.email} = ${rfm.email} ;;
  }

  join: meta_ads {
    type: left_outer
    relationship: many_to_many
    sql_on: ${sales.date} = ${meta_ads.ad_date_date} ;;
  }

  join: google_ads {
    type: left_outer
    relationship: many_to_many
    sql_on: ${sales.date} = ${google_ads.ad_date} ;;
  }
}

explore: rfm {
  join: sales {
    type: left_outer
    relationship: one_to_many
    sql_on: ${rfm.user_id} = ${sales.user_id} OR ${rfm.email} = ${sales.email} ;;
  }
}

explore: meta_ads {}

explore: google_ads {}
