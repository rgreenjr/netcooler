class Comment < ActiveRecord::Base
  
  include Authorable, Rateable
    
  belongs_to  :user
  belongs_to  :commentable, :polymorphic => true
  
  validates_presence_of :body, :user
  validates_length_of   :body, :maximum => 2048
  
  before_validation do |comment|
    if comment.body
      comment.body.strip!
      comment.body = ActionController::Base.helpers.strip_tags(comment.body)
    end
  end
  
  before_save do |comment|
    comment.body_html = ActionController::Base.helpers.simple_format(comment.body)
    comment.body_html = ActionController::Base.helpers.auto_link(comment.body_html)
  end
  
end
