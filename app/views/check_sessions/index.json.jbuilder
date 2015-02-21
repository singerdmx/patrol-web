json.array!(@check_sessions) do |check_session|
  json.extract! check_session, :id
  json.url check_session_url(check_session, format: :json)
end
