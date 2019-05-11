connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"

include: "*.view.lkml"

# persist_with: dg_bc360_clients

label: "BC360 - Rankings"

explore: arch_terms_base {
  join: mx_rankings_flat {
    type: left_outer
    relationship: many_to_many
    sql_on: ${arch_terms_base.search_term} = ${mx_rankings_flat.search_term} ;;
  }

}
