connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"

include: "*.view.lkml"

persist_with: dg_bc360_rankings

label: "Beaumont Health"

explore: arch_terms_base {
  label: "BH - Rankings [ALL]"
  join: mx_rankings_core {
    type: left_outer
    relationship: many_to_many
    sql_on: ${arch_terms_base.search_term} = ${mx_rankings_core.search_term} ;;
  }

}
