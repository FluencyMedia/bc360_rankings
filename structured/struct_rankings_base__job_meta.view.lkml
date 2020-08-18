view: struct_rankings_base__job_meta {
  label: "Job Details"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: batch_id {
    type: string
    sql: ${TABLE}.batch_id ;;
  }

  dimension: cid {
    primary_key: yes
    type: string
    sql: ${TABLE}.cid ;;
  }


  measure: num_results_total {
    label: "# Results (Total)"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${TABLE}.cid ;;
  }

  dimension_group: created {
    hidden: yes
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
    sql: ${TABLE}.created ;;
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

  dimension: source {
    hidden: yes
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: timestamp {
    hidden: yes
    type: string
    sql: ${TABLE}.timestamp ;;
  }
}
