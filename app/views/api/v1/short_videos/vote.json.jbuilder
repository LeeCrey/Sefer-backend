# frozen_string_literal: true

def to_human(value)
  number_to_human(value, format: '%n%u', units: { thousand: 'K', million: 'M' })
end

json.okay true
json._message t('vote', operation: @voted ? 'removed' : 'added')

json.short_video do
  json.extract! @video, :id
  json.voted !@voted

  if @post.cached_votes_up.positive?
    val_t = if @video.cached_votes_up == 1
              'likes.single'
            else
              'likes.multiple'
            end
    json.votes_count t(val_t, value: to_human(@video.cached_votes_up))
  end
end
