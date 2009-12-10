module Authorable

  def author?(user)
    user and user.id == user_id
  end

  def editable_by?(user)
    user and ((user.id == user_id and fresh?) or user.admin?)
  end

  def fresh?
    Time.now - created_at < 5.minutes
  end

end