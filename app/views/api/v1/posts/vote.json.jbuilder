# frozen_string_literal: true

json.okay true
json._message t('vote', operation: @voted ? 'removed' : 'added')

json.post do
  json.extract! @post, :id
  json.voted !@voted
  json.votes_count @post.cached_votes_up
end
