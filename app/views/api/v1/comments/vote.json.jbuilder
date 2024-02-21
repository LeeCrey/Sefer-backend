# frozen_string_literal: true

def to_human(value)
  number_to_human(value, format: '%n%u', units: { thousand: 'K', million: 'M' })
end

json.okay true
json._message t('vote', operation: @voted ? 'removed' : 'added')

json.comment do
  json.extract! @comment, :id
  json.voted !@voted

  if @comment.cached_votes_up.positive?
    val_t = if @comment.cached_votes_up == 1
              'likes.single'
            else
              'likes.multiple'
            end
    json.votes_count t(val_t, value: to_human(@comment.cached_votes_up))
  end
end
