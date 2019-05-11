view: arch_terms_base {
  # sql_table_name: mx_rankings.arch_terms_base_gs ;;

  derived_table: {
    sql: SELECT
          ROW_NUMBER() OVER () row_index,
          *
        FROM `bc360-main.mx_rankings.arch_terms_base_gs`;;
  }

  dimension: row_index {
    type: number
    primary_key: yes
    hidden: yes
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }

  dimension: funnel_position {
    type: string
    sql: ${TABLE}.Funnel_Position ;;
  }

  dimension: offering {
    type: string
    sql: ${TABLE}.Offering ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}.Search_Term ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.Service ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.Specialty ;;
  }

  dimension: tier {
    type: string
    sql: ${TABLE}.Tier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
