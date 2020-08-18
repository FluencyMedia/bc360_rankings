include: "/**/*.view.lkml"

view: struct_rankings_base__urls {
  label: "URL Details"
  dimension: directory {
    type: string
    sql: ${TABLE}.directory ;;
  }

  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
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
  }

  dimension: result_url {
    primary_key: yes
    type: string
    sql: ${TABLE}.result_url ;;
  }

}
