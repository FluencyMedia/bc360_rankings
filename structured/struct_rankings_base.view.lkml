include: "/**/*.view.lkml"

view: struct_rankings_base {
  label: "Ranking Fields"

  # derived_table: {
  #   datagroup_trigger: dg_bc360_rankings
  #
  #   sql: SELECT
  #         ROW_NUMBER() OVER () row_index,
  #         *
  #       FROM `bc360-main.mx_rankings.struct_rankings_base`  ;;
  # }

  sql_table_name: bc360-main.mx_rankings.struct_rankings_base ;;

  dimension: row_index {
    hidden: yes
    primary_key: yes
  }

  dimension: engine {
    label: "Search Engine"
    description: "google | google-mobile"

    type: string
    sql: ${TABLE}.engine ;;
  }

  dimension: funnel_position {
    label: "Funnel Position"
    description: "Upper Funnel | Middle Funnel | Lower Funnel"
    type: string
    sql: ${TABLE}.funnel_position ;;
  }

  dimension: job_meta {
    hidden: yes
    description: "Nested record with job information"
    sql: ${TABLE}.job_meta ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: offering {
    type: string
    sql: ${TABLE}.offering ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: result_details {
    hidden: yes
    description: "Nested record with result details"
    sql: ${TABLE}.result_details ;;
  }

  dimension_group: scan_month {
    type: time
    timeframes: [
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.scan_month ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}.search_term ;;
  }

  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
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

  dimension: urls {
    description: "Nested record with URL details"
    hidden: yes
    sql: ${TABLE}.urls ;;
  }

  dimension: domains {
    description: "Nested record with domain details"
    hidden: yes
    sql: ${TABLE}.urls ;;
  }

  measure: num_terms_scanned {
    label: "# Terms Scanned"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${TABLE}.search_term ;;
  }

  measure: num_terms_returned {
    label: "# Terms Returned"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${TABLE}.search_term ;;
    filters: {
      field: dim_results_count
      value: ">0"
    }
  }

  measure: num_terms_unranked {
    label: "# Terms Unranked"
    type: number
    value_format_name: decimal_0
    sql: ${num_terms_scanned}-${num_terms_returned} ;;
  }

  measure: share_terms_ranked {
    label: "% Ranked"
    type: number
    value_format_name: percent_1
    sql: NULLIF((1.0*(${num_terms_returned})/NULLIF(${num_terms_scanned},0)),0) ;;
  }

  dimension: dim_results_count {
    label: "# Results [01]"
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: (SELECT count(*) FROM UNNEST(${TABLE}.urls));;
  }

  measure: num_results {
    label: "# Results"
    type: sum
    value_format_name: decimal_0
    sql: ${dim_results_count} ;;
  }

  dimension: dim_pages_count {
    label: "# Pages [Dimension]"
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: (SELECT COUNT(DISTINCT path_full) FROM UNNEST(${TABLE}.urls)) ;;
  }

  measure: num_pages {
    label: "# Pages"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${dim_pages_count}),0) ;;
  }

  measure: avg_pages_per_term_scanned {
    label: "@ Pages/Term"
    type: number
    value_format_name: decimal_1
    sql: (1.0*${num_pages})/(NULLIF(${num_terms_scanned},0)) ;;
  }

  measure: avg_results_per_term_scanned {
    label: "@ Results/Term"
    type: number
    value_format_name: decimal_1
    sql: (1.0*${num_results})/(NULLIF(${num_terms_scanned},0)) ;;
  }

  measure: avg_results_per_page {
    label: "@ Results/Page"
    type: number
    value_format_name: decimal_1
    sql: (1.0*${num_results})/(NULLIF(${num_pages},0)) ;;
  }

  measure: rank_max {
    label: "Rank - Max"
    type: min
    sql: ${rank} ;;
  }

  measure: rank_min {
    label: "Rank - Min"
    type: max
    sql: ${rank} ;;
  }

  measure: rank_avg {
    label: "Rank - Avg"
    type: average
    value_format_name: decimal_1
    sql: ${rank} ;;
  }

  dimension: rank_first_page {
    label: "Rank - First Page"
    description: "First Page > Ranked > Unranked"
    case: {
      when: {
        sql: ${rank} = 10;;
        label: "First Page"
      }
      when: {
        sql: ${rank} >= 50 ;;
        label: "Ranked"
      }
      else: "Unranked"
    }
  }

  dimension: result_qualified{
    label: "Result - Qualified"
    description: "Categorizes whether unique result qualifies as meaningful"
    type: yesno

    sql: (${rank_first_page} = "First Page") AND (${funnel_position} != "Upper Funnel") ;;
  }


}
