connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"

include: "*.view.lkml"

persist_with: dg_bc360_rankings

label: "BC360 - All Clients"

explore: arch_terms_base {
  label: "BC360 - Rankings [All]"
  join: mx_rankings_core {
    type: left_outer
    relationship: many_to_many
    sql_on: # ${arch_terms_base.search_term} = ${mx_rankings_core.search_term} AND
            ${arch_terms_base.scan_month} = ${mx_rankings_core.scan_month}  ;;
  }
}


explore: struct_rankings_base {
  label: "BC360 - Ranking [TEST]"

  join: struct_rankings_base__urls {
    sql: ,UNNEST(struct_rankings_base.urls) as urls ;;
    relationship: one_to_many
  }

  join: struct_rankings_base__result_details {
    sql: ,UNNEST(struct_rankings_base.result_details) as result_details ;;
    relationship: one_to_many
  }

}
