view: struct_rankings_base__result_details {
  label: "Result Details"
  dimension: postcode {
    label: "Postcode"
    hidden: no
    type: string
    sql: ${TABLE}.postcode ;;
  }

  dimension: sub_rank {
    hidden: yes
    type: string
    sql: ${TABLE}.sub_rank ;;
  }

  dimension: telephone {
    label: "Telephone"
    hidden: no
    type: string
    sql: ${TABLE}.telephone ;;
  }
}
