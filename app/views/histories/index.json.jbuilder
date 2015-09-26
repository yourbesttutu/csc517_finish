json.array!(@histories) do |history|
  json.extract! history, :id, :userid, :bookid, :checkouttime, :returntime
  json.url history_url(history, format: :json)
end
