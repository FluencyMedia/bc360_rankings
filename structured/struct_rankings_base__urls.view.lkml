include: "/**/*.view.lkml"

view: struct_rankings_base__urls {
  label: "URL Details"
  dimension: directory {
    description: "Top-level directory in URL"
    type: string
    sql: ${TABLE}.directory ;;
  }

  dimension: domain {
    description: "Includes subdomain ('doctors.beaumont.org' vs 'beaumont.org')"
    type: string
    sql: ${TABLE}.domain ;;
  }

  dimension: host {
    description: "Ignores subdomain ('doctors.beaumont.org' vs 'beaumont.org')"
    type: string
    sql: CONCAT(ARRAY_REVERSE(SPLIT(${TABLE}.domain,"."))[SAFE_OFFSET(1)],".",ARRAY_REVERSE(SPLIT(${TABLE}.domain,"."))[SAFE_OFFSET(0)]) ;;
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
