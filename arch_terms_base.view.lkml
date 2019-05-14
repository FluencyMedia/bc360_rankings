view: arch_terms_base {
  label: "Search Term Architecture"

  derived_table: {
    datagroup_trigger: dg_bc360_rankings

    sql: SELECT
          ROW_NUMBER() OVER () row_index,
          *
        FROM `bc360-main.mx_rankings.flat_terms`;;
  }

  dimension: row_index {
    type: number
    primary_key: yes
    hidden: yes
  }

  dimension: scan_month {
    type: date
    hidden: yes
    sql: ${TABLE}.scan_month ;;
  }

  dimension: funnel_position {
    type: string
    sql: ${TABLE}.funnel_position ;;
  }

  dimension: offering {
    type: string
    sql: ${TABLE}.offering ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}.search_term ;;
  }

  measure: search_terms_scanned {
    label: "# Terms Scanned (Unique)"
    description: "Count of unique terms in scanned set"
    type: max
    sql: ${TABLE}.search_terms_scanned ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.service ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.specialty ;;
  }

  dimension: tier {
    type: string
    sql: ${TABLE}.tier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
