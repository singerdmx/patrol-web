json.array! @check_points do |point|
  json.id point.id
  json.description point.description
  json.period_unit point.period_unit
  json.hasld point.hasld
  json.standard point.standard
  json.status point.status
  json.hi_warn point.hi_warn
  json.period point.period
  json.warn_type point.warn_type
  json.site_id point.site_id
  json.tpm_num point.tpm_num
  json.operator point.operator
  json.lo_warn point.lo_warn
  json.tpm_type point.tpm_type
  json.lo_danger point.lo_danger
  json.looknum point.looknum
  json.type point.type
  json.barcode point.barcode

  json.routes point.check_routes.map {   |route|
    route.id
  }
  json.asset point.asset.id
end

