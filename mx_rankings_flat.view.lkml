view: mx_rankings_flat {
  # sql_table_name: mx_rankings.mx_rankings_flat_dp ;;

  derived_table: {
    sql: SELECT
          # ROW_NUMBER() OVER () row_index,
          *
        FROM `bc360-main.mx_rankings.mx_rankings_flat_dp`;;
  }

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes

    sql: ${TABLE}.id ;;
  }

  dimension: batch_id {
    type: string
    sql: ${TABLE}.batch_id ;;
  }

  dimension: cid {
    hidden: yes

    type: string
    sql: ${TABLE}.cid ;;
  }

  dimension_group: scanned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.created AS TIMESTAMP) ;;
  }

  dimension: engine {
    type: string
    sql: ${TABLE}.engine ;;
  }

  dimension: job_id {
    hidden: yes

    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: job_status {
    hidden: yes

    type: string
    sql: ${TABLE}.job_status ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: page {
    type: number
    sql: ${TABLE}.page ;;
  }

  dimension: postcode {
    type: string
    sql: ${TABLE}.postcode ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: result_url {
    type: string
    sql: ${TABLE}.result_url ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}.search_term ;;
  }

  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
  }

  dimension: source {
    # hidden: yes

    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: sub_rank {
    hidden: yes

    type: string
    sql: ${TABLE}.sub_rank ;;
  }

  dimension: telephone {
    hidden: yes

    type: string
    sql: ${TABLE}.telephone ;;
  }

  dimension: timestamp {
    hidden: yes

    type: string
    sql: ${TABLE}.timestamp ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: rank_min {
    type: min
    sql: ${TABLE}.rank ;;
  }
}
