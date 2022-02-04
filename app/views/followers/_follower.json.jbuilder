json.extract! follower, :id, :user_id, :follow, :created_at, :updated_at
json.url follower_url(follower, format: :json)
