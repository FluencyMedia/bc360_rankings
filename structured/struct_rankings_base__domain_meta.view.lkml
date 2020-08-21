include: "/**/*.view.lkml"

view: struct_rankings_base__domain_meta {
  label: "Domain Details"

  dimension: client {
    description: "Client"
    type: string
    sql: ${TABLE}.client ;;
  }

  dimension: organization {
    description: "Organization"
    type: string
    sql: ${TABLE}.organization ;;
  }

  dimension: category {
    description: "Category"
    type: string
    sql: ${TABLE}.category ;;
  }
}
