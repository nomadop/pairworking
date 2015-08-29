json.array!(@pairs) do |pair|
  json.extract! pair, :id, :grad1_id, :grad2_id, :pair_name, :pair_time, :status, :story
  json.url pair_url(pair, format: :json)
end
