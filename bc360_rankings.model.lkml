connection: "bc360_main"

include: "//bc360_admin/**/*bc360_triggers.lkml"

include: "/**/*.view.lkml"

persist_with: dg_bc360_rankings

label: "BC360 - All Clients"

explore: struct_rankings_base {
  view_label: "Rankings - ALL"
  label: "BC360 - Rankings"

  hidden: no

  join: struct_rankings_base__urls {
    sql: LEFT JOIN UNNEST(struct_rankings_base.urls) as struct_rankings_base__urls ;;
    relationship: one_to_many
  }

  join: struct_rankings_base__result_details {
    sql: LEFT JOIN UNNEST(struct_rankings_base.result_details) as struct_rankings_base__result_details ;;
    relationship: one_to_many
  }

  join: struct_rankings_base__domain_meta {
    sql: LEFT JOIN UNNEST(struct_rankings_base.domain_meta) as struct_rankings_base__domain_meta ;;
    relationship: one_to_many
  }

  join: location_meta {
    relationship: many_to_one
    sql_on: ${struct_rankings_base.location} = ${location_meta.zipkey} ;;
  }

}


########### LEGACY EXPLORES ###########

explore: arch_terms_base {
  label: "BC360 - Rankings [All]"
  hidden: yes

  join: mx_rankings_core {
    type: left_outer
    relationship: many_to_many
    sql_on: # ${arch_terms_base.search_term} = ${mx_rankings_core.search_term} AND
      ${arch_terms_base.scan_month} = ${mx_rankings_core.scan_month}  ;;
  }
}

explore: bc360_rankings_bc360 {
  from: arch_terms_base
  label: "BC360 - Rankings [FOR REPLACEMENT]"
  hidden: yes
  join: mx_rankings_core {
    type: left_outer
    relationship: many_to_many
    sql_on: # ${bc360_rankings_bc360.search_term} = ${mx_rankings_core.search_term} AND
      ${bc360_rankings_bc360.scan_month} = ${mx_rankings_core.scan_month}  ;;
  }
}
