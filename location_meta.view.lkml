view: location_meta {
  sql_table_name: mx_rankings.location_meta ;;

  dimension: label {
    view_label: "2. Channel Parameters"
    label: "Location"
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

  dimension: zipcode {
    view_label: "2. Channel Parameters"
    label: "Zip Code"
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }
}
