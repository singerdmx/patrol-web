json.array! @check_results do |result|
      json.id result.id
      json.result result.result
      json.status result.status
      json.memo  result.memo
      json.check_time result.check_time
      json.session result.check_session
      json.point result.check_point
end