view: arch_terms_base {
  label: "Search Term Architecture"
  # sql_table_name: mx_rankings.arch_terms_base_gs ;;

  derived_table: {
    sql: SELECT
          ROW_NUMBER() OVER () row_index,
          scan_month,
          * EXCEPT(scan_month)
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
