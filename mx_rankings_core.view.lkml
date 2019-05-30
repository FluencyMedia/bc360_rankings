view: mx_rankings_core {
  label: "Search Term Rankings"

  derived_table: {
    # datagroup_trigger: dg_bc360_rankings

    sql: SELECT
            ROW_NUMBER() OVER () row_index,
            *
          FROM `bc360-main.mx_rankings.mx_rankings_core`;;
  }

  dimension: row_index {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.row_index ;;
  }

  dimension: scan_month {
    type: date
    hidden: yes
    sql: ${TABLE}.scan_month ;;
  }

  dimension_group: month {

    type: time

    timeframes: [
      month,
      quarter,
      year
    ]

    convert_tz: no
    datatype: date
    sql: ${TABLE}.scan_month ;;  }

  dimension: directory {
    type: string
    sql: ${TABLE}.directory ;;
  }

  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
  }

  dimension: engine {
    type: string
    sql: ${TABLE}.engine ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: path_full {
    type: string
    sql: ${TABLE}.path_full ;;
  }

  dimension: path_page {
    type: string
    sql: ${TABLE}.path_page ;;
  }

  dimension: path_relative {
    type: string
    sql: ${TABLE}.path_relative ;;
    link: {
      label: "VISIT: {{ mx_rankings_core.page_title._value }}"
      url: "{{ mx_rankings_core.result_url._value }}"
    }
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  measure: rank_max {
    label: "Rank - Max"
    type: min
    sql: ${TABLE}.rank ;;
  }

  dimension: result_url {
    type: string
    sql: ${TABLE}.result_url ;;
  }

  measure: result_urls_total {
    type: sum
    sql: ${TABLE}.result_urls_total ;;
  }

  measure: result_urls_unique {
    label: "# Results (Unique)"
    type: sum
    sql: ${TABLE}.result_urls_unique ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}.search_term ;;
  }

  measure: search_terms_unique {
    label: "# Search Terms (Unique)"
    description: "Count of unique terms from result set"
    type: count_distinct
    sql: ${TABLE}.search_term ;;
  }

  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
