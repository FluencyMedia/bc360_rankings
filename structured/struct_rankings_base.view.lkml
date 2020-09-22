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

    sql: ${TABLE}.row_index ;;
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

  dimension: rank_page {
    label: "Rank - Page"
    type: number
    sql: MOD(CAST(${TABLE}.rank AS INT64), 10) ;;
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
    order_by_field: serv_spec_term_order
    sql: ${TABLE}.search_term ;;
  }

  dimension: is_term_branded {
    label: "Is Branded?"
    type: yesno
    sql: ${search_term} LIKE "%beaumont%" ;;
  }

  dimension: branded_vs_unbranded {
    label: "Branded/Unbranded"
    type: string
    sql: IF(${search_term} LIKE "%beaumont%", "Branded", "Unbranded") ;;

  }

  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.service ;;
  }

  dimension: serv_spec_order {
    hidden: yes
    sql: CONCAT(${service},"-",${specialty}) ;;
    alpha_sort: yes
  }

  dimension: specialty {
    type: string
    order_by_field: serv_spec_order
    sql: ${TABLE}.specialty ;;

  }

  dimension: serv_spec_term_order {
    hidden: yes
    sql: CONCAT(${service},"-",${specialty},"-",${search_term}) ;;
    alpha_sort: yes
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

  dimension: domain_meta {
    description: "Nested record with domain details"
    hidden: yes
    sql: ${TABLE}.domain_meta ;;
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
    sql: NULLIF(${num_terms_scanned}-${num_terms_returned}, 0) ;;
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
    sql: NULLIF(${dim_results_count}, 0) ;;
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

  dimension: rank_dim {
    label: "Rank - Dimension"
    type: number

    sql: SAFE_CAST(${rank} AS INT64) ;;
  }

  measure: rank_avg {
    label: "Rank - Avg"
    type: average
    value_format_name: decimal_1
    sql: ${rank_dim} ;;
  }

  measure: rank_median {
    label: "Rank - Median"
    type: median
    value_format_name: decimal_1
    sql: ${rank_dim} ;;
  }

  dimension: rank_first_page {
    label: "Rank - First Page"
    description: "First Page > Ranked > Unranked"
    case: {
      when: {
        sql: ${rank_dim} <= 10;;
        label: "First Page"
      }
      when: {
        sql: ${rank_dim} <= 50 ;;
        label: "Ranked"
      }
      else: "Unranked"
    }
  }

  dimension: rank_binned {
    label: "Ranked Page"
    description: "Rank by page of results"

    case: {
      when: {
        sql: ${rank_dim} <= 10 ;;
        label: "First Page"
      }
      when: {
        sql: ${rank_dim} <= 20 ;;
        label: "Second Page"
      }
      when: {
        sql: ${rank_dim} <= 30 ;;
        label: "Third Page"
      }
      when: {
        sql: ${rank_dim} <= 40 ;;
        label: "Fourth Page"
      }
      when: {
        sql: ${rank_dim} <= 50 ;;
        label: "Fifth Page"
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
