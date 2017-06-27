json.extract! poll, :id, :title, :voting_method, :blind, :created_at, :updated_at
json.url poll_url(poll, format: :json)
