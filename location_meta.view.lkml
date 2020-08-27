view: location_meta {

  derived_table: {
    datagroup_trigger: dg_bc360_rankings

    sql: SELECT
            label,
            latitude,
            longitude,
            location,
            zipcode
          FROM `bc360-main.mx_rankings.location_meta`;;
  }

  dimension: label {
    view_label: "2. Channel Parameters"
    label: "Location Name"
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: latlong {
    view_label: "2. Channel Parameters"
    label: "Lat/Long"
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: location {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: zipkey {
    hidden: yes
    type: string
    sql: CAST(${zipcode} AS STRING) ;;
  }

  dimension: zipcode {
    view_label: "2. Channel Parameters"
    label: "Zip Code"
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }
}
